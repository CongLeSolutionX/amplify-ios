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
    
    public func signIn(username: String,
                       password: String,
                       options: AuthSignInOperation.Request.Options? = nil,
                       listener: AuthSignInOperation.EventListener?) -> AuthSignInOperation {
        let options = options ?? AuthSignInRequest.Options()
        let request = AuthSignInRequest(username: username,
                                        password: password,
                                        options: options)
        let signInOperation = AWSAuthSignInOperation(request,
                                                     authorizer: self.authorizer,
                                                     awsMobileClient: self.awsMobileClient,
                                                     listener: listener)
        queue.addOperation(signInOperation)
        return signInOperation
    }
    
    public func signInWithSocial(provider: AuthSocialProvider,
                                 token: String,
                                 options: AuthSocialSignInOperation.Request.Options? = nil,
                                 listener: AuthSocialSignInOperation.EventListener?) -> AuthSocialSignInOperation {
        
        let options = options ?? AuthSocialSignInRequest.Options()
        let request = AuthSocialSignInRequest(provider: provider,
                                              token: token,
                                              options: options)
        let signInOperation = AWSAuthSocialSignInOperation(request,
                                                           authorizer: self.authorizer,
                                                           listener: listener)
        queue.addOperation(signInOperation)
        return signInOperation
    }
    
    public func signInWithUI(options: AuthUISignInRequest.Options?,
                             listener: AuthUISignInOperation.EventListener?) -> AuthUISignInOperation {
        let options = options ?? AuthUISignInRequest.Options()
        let request = AuthUISignInRequest(options: options)
        let signInOperation = AWSAuthUISignInOperation(request,
                                                       authorizer: self.authorizer,
                                                       listener: listener)
        queue.addOperation(signInOperation)
        return signInOperation
    }
    
    public func currentAuthorizationState(listener: AuthStateOperation.EventListener?) -> AuthStateOperation {
        fatalError()
    }

    public func forgotPassword(username: String,
                               options: AuthForgotPasswordOperation.Request.Options? = nil,
                               listener: AuthForgotPasswordOperation.EventListener?) -> AuthForgotPasswordOperation {
        fatalError()
    }

    public func confirmForgotPassword(username: String,
                                      newPassword: String,
                                      confirmationCode: String,
                                      options: AuthConfirmForgotPwdOperation.Request.Options? = nil,
                                      listener: AuthConfirmForgotPwdOperation.EventListener?) -> AuthConfirmForgotPwdOperation {
        fatalError()
    }

    public func changePassword(currentPassword: String,
                               newPassword: String,
                               options: AuthChangePasswordOperation.Request.Options? = nil,
                               listener: AuthChangePasswordOperation.EventListener?) -> AuthChangePasswordOperation {
        fatalError()
    }
}
