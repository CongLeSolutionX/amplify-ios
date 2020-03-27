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

        guard let jsonValueConfiguration = configuration as? JSONValue else {
            // TODO: Throw error
            return
        }
        let configurationData =  try JSONEncoder().encode(jsonValueConfiguration)
        let authConfig = try JSONDecoder().decode(AWSAuthConfiguration.self, from: configurationData)
        queue = OperationQueue()
        authorizer = AuthorizerAdaptor()
        awsMobileClient = AWSMobileClient.init(configuration: authConfig.awsMobileClientConfiguration())
        awsMobileClient.initialize { (state, error) in
            print(state)
        }
        awsMobileClient.addUserStateListener(self) { (state, dict) in
            print("Listenere -> \(state)")
        }
    }
}



extension AWSAuthConfiguration {

    func awsMobileClientConfiguration() -> [String: Any] {
        var awsConfiguration: [String: Any] = [:]
        awsConfiguration["UserAgent"] = "aws-amplify/cli"
        awsConfiguration["Version"] = "0.1.0"

        let defaultIdManager = ["Default": [:]]
        awsConfiguration["IdentityManager"] = defaultIdManager

        // Cognito Identity Pool
        let cognitoIdentityPool = ["PoolId": identityPoolId, "Region": AWSEndpoint.regionName(from: region)]
        let defaultCognitoIdentity = ["Default": cognitoIdentityPool]
        let cognitoIdentity = ["CognitoIdentity": defaultCognitoIdentity]
        awsConfiguration["CredentialsProvider"] = cognitoIdentity


        // Cognito UserPool
        let cognitoUserPool = ["PoolId": userPoolId,
                               "Region": AWSEndpoint.regionName(from: region),
                               "AppClientId": userPoolAppClientId,
                               "AppClientSecret": userPoolAppClientSecret]
        let defaultCognitoUserPool = ["Default": cognitoUserPool]
        awsConfiguration["CognitoUserPool"] = defaultCognitoUserPool

        // Auth
        let auth = ["WebDomain": userPoolHostedUIDomain,
                    "AppClientId": userPoolAppClientId,
                    "AppClientSecret": userPoolAppClientSecret,
                    "SignInRedirectURI": signInRedirectURI,
                    "SignOutRedirectURI": signOutRedirectURI,
                    "Scopes": hostedUIScopes] as [String : Any]
        let oauth = ["OAuth": auth,
                           "authenticationFlowType": authenticationFlowType] as [String : Any]
        let defaultOauth = ["default": oauth]
        awsConfiguration["Auth"] = defaultOauth
        print("here \(awsConfiguration)")
        return awsConfiguration
    }
}
