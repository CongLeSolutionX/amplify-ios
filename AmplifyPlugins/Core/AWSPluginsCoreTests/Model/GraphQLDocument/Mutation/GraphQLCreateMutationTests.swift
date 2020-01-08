//
// Copyright 2018-2020 Amazon.com,
// Inc. or its affiliates. All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest

@testable import Amplify
@testable import AmplifyTestCommon
@testable import AWSPluginsCore

class GraphQLCreateMutationTests: XCTestCase {

    override func setUp() {
        ModelRegistry.register(modelType: Comment.self)
        ModelRegistry.register(modelType: Post.self)
    }

    override func tearDown() {
        ModelRegistry.reset()
    }

    /// - Given: a `Model` instance
    /// - When:
    ///   - the model is of type `Post`
    ///   - the model has no required associations
    ///   - the mutation is of type `.create`
    /// - Then:
    ///   - check if the generated GraphQL document is a valid mutation:
    ///     - it is named `createPost`
    ///     - it contains an `input` of type `CreatePostInput`
    ///     - it has a list of fields with no nested models
    func testCreateGraphQLMutationFromSimpleModel() {
        let post = Post(title: "title", content: "content", createdAt: Date())
        let document = GraphQLCreateMutation(of: post)
        let expectedQueryDocument = """
        mutation CreatePost($input: CreatePostInput!, $condition: ModelPostConditionInput) {
          createPost(input: $input, condition: $condition) {
            id
            content
            createdAt
            draft
            rating
            title
            updatedAt
            __typename
          }
        }
        """
        XCTAssertEqual(document.name, "createPost")
        XCTAssertEqual(document.stringValue, expectedQueryDocument)
        XCTAssertEqual(document.name, "createPost")
        XCTAssertNotNil(document.variables["input"])
        guard let input = document.variables["input"] as? [String: Any] else {
            XCTFail("The document variables property doesn't contain a valid input")
            return
        }
        XCTAssert(input["title"] as? String == post.title)
        XCTAssert(input["content"] as? String == post.content)
    }

    /// - Given: a `Model` instance
    /// - When:
    ///   - the model is of type `Comment`
    ///   - the model has required associations
    ///   - the mutation is of type `.create`
    /// - Then:
    ///   - check if the generated GraphQL document is a valid mutation:
    ///     - it is named `createComment`
    ///     - it contains an `input` of type `CreateCommentInput`
    ///     - it has a list of fields with a `postId`
    func testCreateGraphQLMutationFromModelWithAssociation() {
        let post = Post(title: "title", content: "content", createdAt: Date())
        let comment = Comment(content: "comment", createdAt: Date(), post: post)
        let document = GraphQLCreateMutation(of: comment)
        let expectedQueryDocument = """
        mutation CreateComment($input: CreateCommentInput!, $condition: ModelCommentConditionInput) {
          createComment(input: $input, condition: $condition) {
            id
            content
            createdAt
            post {
              id
              content
              createdAt
              draft
              rating
              title
              updatedAt
              __typename
            }
            __typename
          }
        }
        """
        XCTAssertEqual(document.name, "createComment")
        XCTAssertEqual(document.stringValue, expectedQueryDocument)
        XCTAssertEqual(document.name, "createComment")
        guard let input = document.variables["input"] as? GraphQLInput else {
            XCTFail("Variables should contain a valid input")
            return
        }
        XCTAssertEqual(input["commentPostId"] as? String, post.id)
    }

    /// - Given: a `Model` instance
    /// - When:
    ///   - the model is of type `Post`
    ///   - the model has no required associations
    ///   - the mutation is of type `.create`
    /// - Then:
    ///   - check if the generated GraphQL document is a valid mutation:
    ///     - it is named `createPost`
    ///     - it contains an `input` of type `CreatePostInput`
    ///     - it has a list of fields with no nested models
    func testCreateGraphQLMutationFromSimpleModelWithSyncEnabled() {
        let post = Post(title: "title", content: "content", createdAt: Date())
        let document = GraphQLCreateMutation(of: post)
        let syncEnabledDocument = SyncEnabledGraphQLDocument(graphqQLDocument: document)
        let expectedQueryDocument = """
        mutation CreatePost($input: CreatePostInput!, $condition: ModelPostConditionInput) {
          createPost(input: $input, condition: $condition) {
            id
            content
            createdAt
            draft
            rating
            title
            updatedAt
            __typename
            _version
            _deleted
            _lastChangedAt
          }
        }
        """
        XCTAssertEqual(syncEnabledDocument.name, "createPost")
        XCTAssertEqual(syncEnabledDocument.stringValue, expectedQueryDocument)
        XCTAssertEqual(syncEnabledDocument.name, "createPost")
        XCTAssertNotNil(syncEnabledDocument.variables["input"])
        guard let input = syncEnabledDocument.variables["input"] as? [String: Any] else {
            XCTFail("The document variables property doesn't contain a valid input")
            return
        }
        XCTAssert(input["title"] as? String == post.title)
        XCTAssert(input["content"] as? String == post.content)
    }

    /// - Given: a `Model` instance
    /// - When:
    ///   - the model is of type `Comment`
    ///   - the model has required associations
    ///   - the mutation is of type `.create`
    /// - Then:
    ///   - check if the generated GraphQL document is a valid mutation:
    ///     - it is named `createComment`
    ///     - it contains an `input` of type `CreateCommentInput`
    ///     - it has a list of fields with a `postId`
    func testCreateGraphQLMutationFromModelWithAssociationWithSyncEnabled() {
        let post = Post(title: "title", content: "content", createdAt: Date())
        let comment = Comment(content: "comment", createdAt: Date(), post: post)
        let document = GraphQLCreateMutation(of: comment)
        let syncEnabledDocument = SyncEnabledGraphQLDocument(graphqQLDocument: document)
        let expectedQueryDocument = """
        mutation CreateComment($input: CreateCommentInput!, $condition: ModelCommentConditionInput) {
          createComment(input: $input, condition: $condition) {
            id
            content
            createdAt
            post {
              id
              content
              createdAt
              draft
              rating
              title
              updatedAt
              __typename
              _version
              _deleted
              _lastChangedAt
            }
            __typename
            _version
            _deleted
            _lastChangedAt
          }
        }
        """
        XCTAssertEqual(syncEnabledDocument.name, "createComment")
        XCTAssertEqual(syncEnabledDocument.stringValue, expectedQueryDocument)
        XCTAssertEqual(syncEnabledDocument.name, "createComment")
        guard let input = syncEnabledDocument.variables["input"] as? GraphQLInput else {
            XCTFail("Variables should contain a valid input")
            return
        }
        XCTAssertEqual(input["commentPostId"] as? String, post.id)
    }
}
