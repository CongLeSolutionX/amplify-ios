//
// Copyright 2018-2020 Amazon.com,
// Inc. or its affiliates. All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Amplify
import Foundation
import SQLite
import AWSPluginsCore

/// [SQLite](https://sqlite.org) `StorageEngineAdapter` implementation. This class provides
/// an integration layer between the AppSyncLocal `StorageEngine` and SQLite for local storage.
final class SQLiteStorageEngineAdapter: StorageEngineAdapter {

    internal var connection: Connection!
    private var dbFilePath: URL?

    convenience init(databaseName: String = "database") throws {
        guard let documentsPath = getDocumentPath() else {
            preconditionFailure("Could not create the database. The `.documentDirectory` is invalid")
        }
        var dbFilePath = documentsPath.appendingPathComponent("\(databaseName).db")
        let path = dbFilePath.absoluteString

        let connection: Connection
        do {
            connection = try Connection(path)

            var urlResourceValues = URLResourceValues()
            urlResourceValues.isExcludedFromBackup = true
            try dbFilePath.setResourceValues(urlResourceValues)
        } catch {
            throw DataStoreError.invalidDatabase(path: path, error)
        }

        try self.init(connection: connection, dbFilePath: dbFilePath)
    }

    internal init(connection: Connection, dbFilePath: URL? = nil) throws {
        self.connection = connection
        self.dbFilePath = dbFilePath
        try SQLiteStorageEngineAdapter.initializeDatabase(connection: connection)
        log.verbose("Initialized \(connection)")
    }

    static func initializeDatabase(connection: Connection) throws {
        log.debug("Initializing database connection: \(String(describing: connection))")

        if log.logLevel >= .verbose {
            connection.trace { self.log.verbose($0) }
        }

        let databaseInitializationStatement = """
        pragma auto_vacuum = full;
        pragma encoding = "utf-8";
        pragma foreign_keys = on;
        pragma case_sensitive_like = off;
        """

        try connection.execute(databaseInitializationStatement)
    }

    func setUp(models: [Model.Type]) throws {
        log.debug("Setting up \(models.count) models")

        let createTableStatements = models
            .sortByDependencyOrder()
            .map { CreateTableStatement(modelType: $0).stringValue }
            .joined(separator: "\n")

        do {
            try connection.execute(createTableStatements)
        } catch {
            throw DataStoreError.invalidOperation(causedBy: error)
        }
    }

    func save<M: Model>(_ model: M, condition: QueryPredicate? = nil, completion: DataStoreCallback<M>) {
        do {
            let modelType = type(of: model)
            let modelExists = try exists(modelType, withId: model.id)

            if !modelExists {
                if condition != nil {
                    let dataStoreError = DataStoreError.invalidCondition(
                        "Cannot apply a condition on model which does not exist.",
                        "Save the model instance without a condition first.")
                    completion(.failure(causedBy: dataStoreError))
                    return
                }

                let statement = InsertStatement(model: model)
                _ = try connection.prepare(statement.stringValue).run(statement.variables)
            }

            if modelExists {
                if condition != nil {
                    let modelExistsWithCondition = try exists(modelType, withId: model.id, predicate: condition)
                    if !modelExistsWithCondition {
                        let dataStoreError = DataStoreError.invalidCondition(
                        "Save failed due to condition did not match existing model instance.",
                        "The save will continue to fail until the model instance is updated.")
                        completion(.failure(causedBy: dataStoreError))
                        return
                    }
                }

                let statement = UpdateStatement(model: model, condition: condition)
                _ = try connection.prepare(statement.stringValue).run(statement.variables)
            }

            // load the recent saved instance and pass it back to the callback
            query(modelType, predicate: field("id").eq(model.id)) {
                switch $0 {
                case .success(let result):
                    if let saved = result.first {
                        completion(.success(saved))
                    } else {
                        completion(.failure(.nonUniqueResult(model: modelType.modelName,
                                                             count: result.count)))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(causedBy: error))
        }
    }

    func delete<M: Model>(_ modelType: M.Type,
                          predicate: QueryPredicate,
                          completion: (DataStoreResult<[M]>) -> Void) {
        do {
            let statement = DeleteStatement(modelType: modelType, predicate: predicate)
            _ = try connection.prepare(statement.stringValue).run(statement.variables)
            completion(.success([]))
        } catch {
            completion(.failure(causedBy: error))
        }
    }

    func delete<M: Model>(_ modelType: M.Type,
                          withId id: Model.Identifier,
                          completion: (DataStoreResult<Void>) -> Void) {
        delete(untypedModelType: modelType, withId: id, completion: completion)
    }

    func delete(untypedModelType modelType: Model.Type,
                withId id: Model.Identifier,
                completion: DataStoreCallback<Void>) {
        do {
            let statement = DeleteStatement(modelType: modelType, withId: id)
            _ = try connection.prepare(statement.stringValue).run(statement.variables)
            completion(.emptyResult)
        } catch {
            completion(.failure(causedBy: error))
        }
    }

    func query<M: Model>(_ modelType: M.Type,
                         predicate: QueryPredicate? = nil,
                         paginationInput: QueryPaginationInput? = nil,
                         completion: DataStoreCallback<[M]>) {
        query(modelType,
              predicate: predicate,
              additionalStatements: nil,
              completion: completion)
    }

    func query<M: Model>(_ modelType: M.Type,
                         predicate: QueryPredicate? = nil,
                         paginationInput: QueryPaginationInput? = nil,
                         additionalStatements: String? = nil,
                         completion: DataStoreCallback<[M]>) {
        do {
            let statement = SelectStatement(from: modelType,
                                            predicate: predicate,
                                            paginationInput: paginationInput,
                                            additionalStatements: additionalStatements)
            let rows = try connection.prepare(statement.stringValue).run(statement.variables)
            let result: [M] = try rows.convert(to: modelType)
            completion(.success(result))
        } catch {
            completion(.failure(causedBy: error))
        }
    }

    func exists(_ modelType: Model.Type,
                withId id: Model.Identifier,
                predicate: QueryPredicate? = nil) throws -> Bool {
        let schema = modelType.schema
        let primaryKey = schema.primaryKey.sqlName
        var sql = "select count(\(primaryKey)) from \(schema.name) where \(primaryKey) = ?"
        var variables: [Binding?] = [id]
        if let predicate = predicate {
            let conditionStatement = ConditionStatement(modelType: modelType,
                                                        predicate: predicate)
            sql = """
            \(sql)
            \(conditionStatement.stringValue)
            """

            variables.append(contentsOf: conditionStatement.variables)
        }

        let result = try connection.scalar(sql, variables)
        if let count = result as? Int64 {
            if count > 1 {
                throw DataStoreError.nonUniqueResult(model: modelType.modelName,
                                                     count: Int(count))
            }
            return count == 1
        }
        return false
    }

    func queryMutationSync(forAnyModel anyModel: AnyModel) throws -> MutationSync<AnyModel>? {
        let model = anyModel.instance
        let results = try queryMutationSync(for: [model])
        return results.first
    }

    func queryMutationSync(for models: [Model]) throws -> [MutationSync<AnyModel>] {
        let statement = SelectStatement(from: MutationSyncMetadata.self)
        let primaryKey = MutationSyncMetadata.schema.primaryKey.sqlName
        // This is a temp workaround since we don't currently support the "in" operator
        // in query predicates (this avoids the 1 + n query problem). Consider adding "in" support
        let placeholders = Array(repeating: "?", count: models.count).joined(separator: ", ")
        let sql = statement.stringValue + "\nwhere \(primaryKey) in (\(placeholders))"

        // group models by id for fast access when creating the tuple
        let modelById = Dictionary(grouping: models, by: { $0.id }).mapValues { $0.first! }
        let ids = [String](modelById.keys)
        let rows = try connection.prepare(sql).bind(ids)

        let syncMetadataList = try rows.convert(to: MutationSyncMetadata.self)
        let mutationSyncList = try syncMetadataList.map { syncMetadata -> MutationSync<AnyModel> in
            guard let model = modelById[syncMetadata.id] else {
                throw DataStoreError.invalidOperation(causedBy: nil)
            }
            let anyModel = try model.eraseToAnyModel()
            return MutationSync<AnyModel>(model: anyModel, syncMetadata: syncMetadata)
        }
        return mutationSyncList
    }

    func queryMutationSyncMetadata(for modelId: Model.Identifier) throws -> MutationSyncMetadata? {
        let modelType = MutationSyncMetadata.self
        let statement = SelectStatement(from: modelType, predicate: field("id").eq(modelId))
        let rows = try connection.prepare(statement.stringValue).run(statement.variables)
        let result = try rows.convert(to: modelType)
        return try result.unique()
    }

    func queryModelSyncMetadata(for modelType: Model.Type) throws -> ModelSyncMetadata? {
        let statement = SelectStatement(from: ModelSyncMetadata.self,
                                        predicate: field("id").eq(modelType.modelName))
        let rows = try connection.prepare(statement.stringValue).run(statement.variables)
        let result = try rows.convert(to: ModelSyncMetadata.self)
        return try result.unique()
    }

    func transaction(_ transactionBlock: BasicThrowableClosure) throws {
        try connection.transaction {
            try transactionBlock()
        }
    }

    func clear(completion: @escaping DataStoreCallback<Void>) {
        guard let dbFilePath = dbFilePath else {
            log.error("Attempt to clear DB, but file path was empty")
            completion(.failure(causedBy: DataStoreError.invalidDatabase(path: "Database path not set", nil)))
            return
        }
        connection = nil
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: dbFilePath)
        } catch {
            log.error("Failed to delete database file located at: \(dbFilePath), error: \(error)")
            completion(.failure(causedBy: DataStoreError.invalidDatabase(path: dbFilePath.absoluteString, error)))
        }
        completion(.successfulVoid)
    }
}

// MARK: - Private Helpers

/// Helper function that can be used as a shortcut to access the user's document
/// directory on the underlying OS. This is used to create the SQLite database file.
///
/// - Returns: the path to the user document directory.
private func getDocumentPath() -> URL? {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
}

extension SQLiteStorageEngineAdapter: DefaultLogger { }
