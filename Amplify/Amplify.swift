//
// Copyright 2018-2020 Amazon.com,
// Inc. or its affiliates. All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

/// At its core, the Amplify class is simply a router that provides clients top-level access to categories and
/// configuration methods. It provides convenient access to default plugins via the top-level category properties,
/// but clients can access specific plugins by invoking `getPlugin` on a category and issuing methods directly to
/// that plugin.
///
/// - Warning: It is a serious programmer to invoke any of the category APIs (like `Analytics.record()` or
/// `API.mutate()`) without first registering plugins via `Amplify.add(plugin:)` and configuring Amplify via
/// `Amplify.configure()`. Such access will cause a preconditionFailure.
///
/// There are two exceptions to this. The `Logging` and `Hub` categories are configured with a default plugin that is
/// available at initialization.
public class Amplify {

    /// If `true`, `configure()` has already been invoked, and subsequent calls to `configure` will throw a
    /// ConfigurationError.amplifyAlreadyConfigured error.
    static var isConfigured = false

    // Storage for the categories themselves, which will be instantiated during configuration, and cleared during reset.
    // It is not supported to mutate these category properties. They are `var` to support the `reset()` method for
    // ease of testing.
    public static internal(set) var Analytics = AnalyticsCategory()
    public static internal(set) var API: APICategory = AmplifyAPICategory()
    public static internal(set) var DataStore = DataStoreCategory()
    public static internal(set) var Hub = HubCategory()
    public static internal(set) var Logging = LoggingCategory()
    public static internal(set) var Predictions = PredictionsCategory()
    public static internal(set) var Storage = StorageCategory()
    public static internal(set) var Auth = AuthCategory()

    /// Adds `plugin` to the Analytics category
    ///
    /// - Parameter plugin: The AnalyticsCategoryPlugin to add
    public static func add<P: Plugin>(plugin: P) throws {
        log.debug("Adding plugin: \(plugin))")
        switch plugin {
        case let plugin as AnalyticsCategoryPlugin:
            try Analytics.add(plugin: plugin)
        case let plugin as APICategoryPlugin:
            try API.add(plugin: plugin)
        case let plugin as DataStoreCategoryPlugin:
            try DataStore.add(plugin: plugin)
        case let plugin as HubCategoryPlugin:
            try Hub.add(plugin: plugin)
        case let plugin as LoggingCategoryPlugin:
            try Logging.add(plugin: plugin)
        case let plugin as PredictionsCategoryPlugin:
            try Predictions.add(plugin: plugin)
        case let plugin as StorageCategoryPlugin:
            try Storage.add(plugin: plugin)
        case let plugin as AuthCategoryPlugin:
            try Auth.add(plugin: plugin)
        default:
            throw PluginError.pluginConfigurationError(
                "Plugin category does not exist.",
                "Verify that the library version is correct and supports the plugin's category.")
        }
    }

}

extension Amplify: DefaultLogger { }
