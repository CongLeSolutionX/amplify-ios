//
//  AWSAuthSignInOperation.swift
//  AWSAuthPlugin
//
//  Created by Roy, Jithin on 3/5/20.
//  Copyright © 2020 Amazon Web Services. All rights reserved.
//

import Foundation

import Amplify
import AWSMobileClient

public class AWSAuthSignInOperation: AmplifyOperation<AuthSignInRequest, Void, AuthSignInResult, AmplifyAuthError>,
AuthSignInOperation {

    let authorizer: AuthorizerBehavior

    init(_ request: AuthSignInRequest,
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

        AWSMobileClient.default().signIn(username: request.username,
                                         password: request.password) { [weak self] (result, error) in

                                            if let error = error {
                                                print(error)
                                                return
                                            }

                                            self?.authorizer.getAuthorization(listener: { (authResult) in
                                                switch authResult {
                                                case .failure(let error):
                                                    break
                                                case .success(let authInfo):
                                                    let signedInResult = AuthSignInResult(authInfo: authInfo)
                                                    self?.dispatch(signedInResult)
                                                }
                                            })


        }
    }

    private func dispatch(_ result: AuthSignInResult) {
        let asyncEvent = AsyncEvent<Void, AuthSignInResult, AmplifyAuthError>.completed(result)
        dispatch(event: asyncEvent)
    }

    private func dispatch(_ error: AmplifyAuthError) {
        let asyncEvent = AsyncEvent<Void, AuthSignInResult, AmplifyAuthError>.failed(error)
        dispatch(event: asyncEvent)
    }

}

