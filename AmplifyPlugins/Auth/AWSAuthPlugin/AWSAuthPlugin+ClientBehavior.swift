//
//  AWSAuthPlugin+ClientBehavior.swift
//  AWSAuthPlugin
//
//  Created by Roy, Jithin on 3/4/20.
//  Copyright © 2020 Amazon Web Services. All rights reserved.
//

import Amplify

extension AWSAuthPlugin {

    public func signUp(username: String,
                       password: String,
                       options: AuthSignUpOperation.Request.Options? = nil,
                       listener: AuthSignUpOperation.EventListener?) -> AuthSignUpOperation {

        let options = options ?? AuthSignUpRequest.Options()
        let request = AuthSignUpRequest(username: username,
                                        password: password,
                                        options: options)

        let signUpOperation = AWSAuthSignUpOperation(request, listener: listener)
        queue.addOperation(signUpOperation)
        return signUpOperation
    }

    public func confirmSignUp(username: String,
                       code: String,
                       options: AuthConfirmSignUpOperation.Request.Options? = nil,
                       listener: AuthConfirmSignUpOperation.EventListener?) -> AuthConfirmSignUpOperation {
        let options = options ?? AuthConfirmSignUpRequest.Options()
        let request = AuthConfirmSignUpRequest(username: username,
                                               code: code,
                                               options: options)

        let confirmSignUpOperation = AWSAuthConfirmSignUpOperation(request, listener: listener)
        queue.addOperation(confirmSignUpOperation)
        return confirmSignUpOperation
    }
}
