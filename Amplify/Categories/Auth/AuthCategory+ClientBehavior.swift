//
// Copyright 2018-2020 Amazon.com,
// Inc. or its affiliates. All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

extension AuthCategory: AuthCategoryClientBehavior {

    public func signUp(username: String,
                       password: String,
                       options: AuthSignUpOperation.Request.Options? = nil,
                       listener: AuthSignUpOperation.EventListener?) -> AuthSignUpOperation {
        return plugin.signUp(username: username,
                             password: password,
                             options: options,
                             listener: listener)
    }

    public func confirmSignUp(username: String,
                              code: String,
                              options: AuthConfirmSignUpOperation.Request.Options? = nil,
                              listener: AuthConfirmSignUpOperation.EventListener?) -> AuthConfirmSignUpOperation {
        return plugin.confirmSignUp(username: username,
                                    code: code,
                                    options: options,
                                    listener: listener)

    }

    public func signIn(username: String,
                       password: String,
                       options: AuthSignInOperation.Request.Options? = nil,
                       listener: AuthSignInOperation.EventListener?) -> AuthSignInOperation {
        return plugin.signIn(username: username,
                             password: password,
                             options: options,
                             listener: listener)
    }

    public func signInWithSocial(provider: AuthSocialProvider,
                                 token: String,
                                 options: AuthSocialSignInOperation.Request.Options? = nil,
                                 listener: AuthSocialSignInOperation.EventListener?) -> AuthSocialSignInOperation {
        return plugin.signInWithSocial(provider: provider,
                                       token: token,
                                       options: options,
                                       listener: listener)
    }

    public func signInWithUI(options: AuthUISignInRequest.Options?,
                             listener: AuthUISignInOperation.EventListener?) -> AuthUISignInOperation {
        return plugin.signInWithUI(options: options,
                                   listener: listener)

    }

    public func currentAuthorizationState(listener: AuthStateOperation.EventListener?) -> AuthStateOperation {
        return plugin.currentAuthorizationState(listener: listener)
    }
}
