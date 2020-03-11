//
//  AWSAuthSocialSignInOperation.swift
//  AWSAuthPlugin
//
//  Created by Roy, Jithin on 3/10/20.
//  Copyright © 2020 Amazon Web Services. All rights reserved.
//

import Foundation

import Amplify
import AWSMobileClient

public class AWSAuthSocialSignInOperation: AmplifyOperation<AuthSocialSignInRequest, Void, AuthSocialSignInResult, AmplifyAuthError>,
AuthSocialSignInOperation {

    let authorizer: AuthorizerBehavior

    init(_ request: AuthSocialSignInRequest,
         authorizer: AuthorizerBehavior,
         listener: EventListener?) {

        self.authorizer = authorizer
        super.init(categoryType: .auth,
                   eventName: HubPayload.EventName.Auth.signIn,
                   request: request,
                   listener: listener)
    }

    override public func main() {
        if isCancelled {
            finish()
            return
        }

        AWSMobileClient.default().federatedSignIn(providerName: IdentityProvider.facebook.rawValue,
                                                  token: request.token) { [weak self] (result, error) in

                                            if let error = error {
                                                print(error)
                                                return
                                            }

                                            self?.authorizer.getAuthorization(listener: { (authResult) in
                                                switch authResult {
                                                case .failure(let error):
                                                    break
                                                case .success(let authInfo):
                                                    let signedInResult = AuthSocialSignInResult(authInfo: authInfo)
                                                    self?.dispatch(signedInResult)
                                                }
                                            })


        }
    }

    private func dispatch(_ result: AuthSocialSignInResult) {
        let asyncEvent = AsyncEvent<Void, AuthSocialSignInResult, AmplifyAuthError>.completed(result)
        dispatch(event: asyncEvent)
    }

    private func dispatch(_ error: AmplifyAuthError) {
        let asyncEvent = AsyncEvent<Void, AuthSocialSignInResult, AmplifyAuthError>.failed(error)
        dispatch(event: asyncEvent)
    }

}
