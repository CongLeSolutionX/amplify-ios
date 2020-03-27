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

    public func signInWithUI(options: AuthUISignInRequest.Options? = nil,
                             listener: AuthUISignInOperation.EventListener?) -> AuthUISignInOperation {
        return plugin.signInWithUI(options: options,
                                   listener: listener)

    }

    public func currentAuthorizationState(listener: AuthStateOperation.EventListener?) -> AuthStateOperation {
        return plugin.currentAuthorizationState(listener: listener)
    }

    public func forgotPassword(username: String,
                               options: AuthForgotPasswordOperation.Request.Options? = nil,
                               listener: AuthForgotPasswordOperation.EventListener?) -> AuthForgotPasswordOperation {
        return plugin.forgotPassword(username: username,
                                     options: options,
                                     listener: listener)
    }

    public func confirmForgotPassword(username: String,
                                      newPassword: String,
                                      confirmationCode: String,
                                      options: AuthConfirmForgotPwdOperation.Request.Options? = nil,
                                      listener: AuthConfirmForgotPwdOperation.EventListener?) -> AuthConfirmForgotPwdOperation {
        return plugin.confirmForgotPassword(username: username,
                                            newPassword: newPassword,
                                            confirmationCode: confirmationCode,
                                            options: options,
                                            listener: listener)
    }

    public func changePassword(currentPassword: String,
                               newPassword: String,
                               options: AuthChangePasswordOperation.Request.Options? = nil,
                               listener: AuthChangePasswordOperation.EventListener?) -> AuthChangePasswordOperation {
        return plugin.changePassword(currentPassword: currentPassword,
                                     newPassword: newPassword,
                                     options: options,
                                     listener: listener)
    }
}
