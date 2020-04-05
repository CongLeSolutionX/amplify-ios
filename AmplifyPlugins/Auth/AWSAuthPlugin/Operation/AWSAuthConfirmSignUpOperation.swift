//
//  AWSAuthConfirmSignUpOperation.swift
//  AWSAuthPlugin
//
//  Created by Roy, Jithin on 3/5/20.
//  Copyright © 2020 Amazon Web Services. All rights reserved.
//

import Foundation

import Amplify
import AWSMobileClient

public class AWSAuthConfirmSignUpOperation: AmplifyOperation<AuthConfirmSignUpRequest, Void, AuthSignUpResult, AmplifyAuthError>,
AuthConfirmSignUpOperation {

    init(_ request: AuthConfirmSignUpRequest,
         listener: EventListener?) {

        super.init(categoryType: .auth,
                   eventName: HubPayload.EventName.Auth.confirmSignUp,
                   request: request,
                   listener: listener)
    }

    override public func main() {
        if isCancelled {
            finish()
            return
        }

        Amplify.Hub.listen(to: .auth,
                           eventName: "") { (payload) in
                            
        }

        AWSMobileClient.default().confirmSignUp(username: request.username,
                                                confirmationCode: request.confirmationCode) {[weak self] (result, error) in
                                                    guard let result = result else {
                                                        return
                                                    }
                                                    
                                                    let userConfirmed = result.signUpConfirmationState == .confirmed ? true: false
                                                    var signUpCodeDelivery: AuthCodeDeliveryDetails? = nil
                                                    if let deliveryDetails = result.codeDeliveryDetails {
                                                        let deliveryMedium = deliveryDetails.deliveryMedium.toAuthCodeDeliveryMedium()
                                                        let attributeName = deliveryDetails.attributeName
                                                        let destination = deliveryDetails.destination
                                                        signUpCodeDelivery = AuthCodeDeliveryDetails(desitination: destination,
                                                                                                     deliveryMedium: deliveryMedium,
                                                                                                     attribuetName: attributeName)

                                                    }
                                                    let signUpResult = AuthSignUpResult(userConfirmed: userConfirmed,
                                                                                        codeDeliveryDetails: signUpCodeDelivery)
                                                    self?.dispatch(signUpResult)

        }

    }

    private func dispatch(_ result: AuthSignUpResult) {
        let asyncEvent = AsyncEvent<Void, AuthSignUpResult, AmplifyAuthError>.completed(result)
        dispatch(event: asyncEvent)
    }

    private func dispatch(_ error: AmplifyAuthError) {
        let asyncEvent = AsyncEvent<Void, AuthSignUpResult, AmplifyAuthError>.failed(error)
        dispatch(event: asyncEvent)
    }
}
