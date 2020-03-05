//
//  AWSAuthSignUpOperation.swift
//  AWSAuthPlugin
//
//  Created by Roy, Jithin on 3/4/20.
//  Copyright © 2020 Amazon Web Services. All rights reserved.
//

import Foundation
import Amplify
import AWSMobileClient

public class AWSAuthSignUpOperation: AmplifyOperation<AuthSignUpRequest, Void, Bool, AmplifyAuthError>,
AuthSignUpOperation {

    init(_ request: AuthSignUpRequest,
         listener: EventListener?) {

        super.init(categoryType: .auth,
                   eventName: HubPayload.EventName.Auth.signUp,
                   request: request,
                   listener: listener)
    }

    override public func main() {
        if isCancelled {
            finish()
            return
        }

        AWSMobileClient.default().signUp(username: request.username,
                                         password: request.password,
                                         userAttributes: request.options.userAttributes ?? [:]) { (result, error) in
                                            print(result)
                                            print(error)
                                            self.dispatch(true)
                                            
        }

    }

    private func dispatch(_ result: Bool) {
        let asyncEvent = AsyncEvent<Void, Bool, AmplifyAuthError>.completed(result)
        dispatch(event: asyncEvent)
    }

    private func dispatch(_ error: AmplifyAuthError) {
        let asyncEvent = AsyncEvent<Void, Bool, AmplifyAuthError>.failed(error)
        dispatch(event: asyncEvent)
    }

}
