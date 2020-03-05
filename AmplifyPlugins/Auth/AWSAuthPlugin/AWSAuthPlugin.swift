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

final public class AWSAuthPlugin: AuthCategoryPlugin {

    /// A queue that regulates the execution of operations.
    var queue: OperationQueue!
    
    /// The unique key of the plugin within the auth category.
    public var key: PluginKey {
        return PluginConstants.awsAuthPluginKey
    }

    /// Instantiates an instance of the AWSS3StoragePlugin.
    public init() {
    }
}
