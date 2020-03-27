//
//  AuthorizerAdaptor.swift
//  AWSAuthPlugin
//
//  Created by Roy, Jithin on 3/10/20.
//  Copyright © 2020 Amazon Web Services. All rights reserved.
//

import Foundation
import Amplify
import AWSMobileClient

class AuthorizerAdaptor: AuthorizerBehavior {

    func refreshAuthorization(credentials: Any?, listener: @escaping AuthorizerListener) {
        getAuthorization(listener: listener)
    }

    func getAuthorization(listener: @escaping AuthorizerListener) {

        AWSMobileClient.default().getTokens { [weak self] (tokens, error) in
            print("Token - \(tokens)")
            print("Token Error - \(error)")
            self?.getIdentityId(userPoolTokens: tokens, callback: listener)
        }
    }

    // MARK: -
    
    private func getIdentityId(userPoolTokens: Tokens?,
                               callback: @escaping AuthorizerListener) {

        AWSMobileClient.default().getIdentityId().continueWith { [weak self] (task) -> Any? in
            if let result = task.result {
                print("Id - \(result)")

                self?.getCredentials(userPoolTokens: userPoolTokens,
                                     id: result as String,
                                     callback: callback)
            } else {
                print("Id Error - \(task.error)")
            }
            return nil
        }
    }

    private func getCredentials(userPoolTokens: Tokens?,
                                id: String? ,
                                callback: (Result<AmplifyAuthInformation, Error>) -> Void) {

        guard let id = id else {
            if let tokens = userPoolTokens {

            } else {

            }
            return
        }
        AWSMobileClient.default().getAWSCredentials { (credentials, error) in
                print("credentials - \(credentials)")
                print("credentials Error - \(error)")
        }
    }
}
