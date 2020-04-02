//
//  AWSAuthUISignInOperation.swift
//  AWSAuthPlugin
//
//  Created by Roy, Jithin on 3/8/20.
//  Copyright © 2020 Amazon Web Services. All rights reserved.
//

import Foundation

import Amplify
import AWSMobileClient

public class AWSAuthUISignInOperation: AmplifyOperation<AuthUISignInRequest, Void, AuthUISignInResult, AmplifyAuthError>,
AuthUISignInOperation {

    let authorizer: AuthorizerBehavior
    
    init(_ request: AuthUISignInRequest,
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

        guard let window = request.options.presentationAnchor else {
            return
        }

        DispatchQueue.main.async {
            let navController = UINavigationController(rootViewController: UIViewController())
            navController.isNavigationBarHidden = true
            navController.modalPresentationStyle = .overCurrentContext

            window.rootViewController?.present(navController, animated: false, completion: { [weak self] in


                AWSMobileClient.default().showSignIn(navigationController: navController,
                                                     hostedUIOptions: HostedUIOptions()) {(state, error) in
                                                        DispatchQueue.main.async {
                                                            print("Closing")
                                                            navController.dismiss(animated: false)
                                                        }
                                                        if let error = error {
                                                            print(error)
                                                            return
                                                        }

                                                        self?.authorizer.getAuthorization(listener: { (authResult) in
                                                            switch authResult {
                                                            case .failure(let error):
                                                                break
                                                            case .success(let authInfo):
                                                                let signedInResult = AuthUISignInResult(authInfo: authInfo)
                                                                self?.dispatch(signedInResult)
                                                            }
                                                        })
                }

            })

        }

    }

    private func dispatch(_ result: AuthUISignInResult) {
        let asyncEvent = AsyncEvent<Void, AuthUISignInResult, AmplifyAuthError>.completed(result)
        dispatch(event: asyncEvent)
    }

    private func dispatch(_ error: AmplifyAuthError) {
        let asyncEvent = AsyncEvent<Void, AuthUISignInResult, AmplifyAuthError>.failed(error)
        dispatch(event: asyncEvent)
    }

}
