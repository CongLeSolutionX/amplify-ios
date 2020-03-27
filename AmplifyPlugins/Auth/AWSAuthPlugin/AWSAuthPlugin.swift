//
//  AWSAuthPlugin.swift
//  AWSAuthPlugin
//
//  Created by Roy, Jithin on 3/4/20.
//  Copyright © 2020 Amazon Web Services. All rights reserved.
//

import Foundation
import Amplify
import AWSPluginsCore
import AWSMobileClient

final public class AWSAuthPlugin: AuthCategoryPlugin {

    /// A queue that regulates the execution of operations.
    var queue: OperationQueue!

    var authorizer: AuthorizerBehavior!

    var awsMobileClient: AWSMobileClient!
    
    /// The unique key of the plugin within the auth category.
    public var key: PluginKey {
        return AuthPluginConstants.awsAuthPluginKey
    }

    /// Instantiates an instance of the AWSS3StoragePlugin.
    public init() {
    }
}
