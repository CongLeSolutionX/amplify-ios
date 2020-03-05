//
//  AWSAuthPlugin+Configure.swift
//  AWSAuthPlugin
//
//  Created by Roy, Jithin on 3/4/20.
//  Copyright © 2020 Amazon Web Services. All rights reserved.
//

import Foundation
import Amplify
import AWSPluginsCore
import AWSMobileClient

extension AWSAuthPlugin {

    /// Configures AWSAuthPlugin with the specified configuration.
    ///
    ///
    /// - Parameter configuration: The configuration specified for this plugin
    /// - Throws:
    ///   - PluginError.pluginConfigurationError: If one of the configuration values is invalid or empty
    public func configure(using configuration: Any) throws {
        queue = OperationQueue()
        AWSMobileClient.default().initialize { (state, error) in
            print(state)
        }
    }
}
