//
// Copyright 2018-2020 Amazon.com,
// Inc. or its affiliates. All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

public protocol AuthCategoryClientBehavior {

    func signUp(username: String,
                password: String,
                options: AuthSignUpOperation.Request.Options?,
                listener: AuthSignUpOperation.EventListener?) -> AuthSignUpOperation

    func confirmSignUp(username: String,
                       code: String,
                       options: AuthConfirmSignUpOperation.Request.Options?,
                       listener: AuthConfirmSignUpOperation.EventListener?) -> AuthConfirmSignUpOperation

    func signIn(username: String,
                password: String,
                options: AuthSignInOperation.Request.Options?,
                listener: AuthSignInOperation.EventListener?) -> AuthSignInOperation

    func signInWithSocial(provider: AuthSocialProvider,
                          token: String,
                          options: AuthSocialSignInOperation.Request.Options?,
                          listener: AuthSocialSignInOperation.EventListener?) -> AuthSocialSignInOperation

    func signInWithUI(options: AuthUISignInOperation.Request.Options?,
                      listener: AuthUISignInOperation.EventListener?) -> AuthUISignInOperation

    func currentAuthorizationState(listener: AuthStateOperation.EventListener?) -> AuthStateOperation
}
