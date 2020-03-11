//
//  AuthorizerBehavior.swift
//  AWSAuthPlugin
//
//  Created by Roy, Jithin on 3/9/20.
//  Copyright © 2020 Amazon Web Services. All rights reserved.
//

import Amplify

protocol AuthorizerBehavior {

    typealias AuthorizerListener = (Result<AmplifyAuthInformation, Error>) -> Void

    func refreshAuthorization(credentials: Any?,
                              listener: @escaping AuthorizerListener)

    func getAuthorization(listener: @escaping AuthorizerListener)
}
