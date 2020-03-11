//
//  CognitoUserPoolAuthInformation.swift
//  AWSAuthPlugin
//
//  Created by Roy, Jithin on 3/5/20.
//  Copyright © 2020 Amazon Web Services. All rights reserved.
//

import Amplify

public struct CognitoUserPoolAuthInformation: AmplifyAuthInformation, CognitoUserPoolTokensProvider {

    public var userPoolTokens: CognitoUserPoolTokens

    public var isSignedIn: Bool // method get the value from AuthUserState

    public var state: AuthUserState

    let awsCredentials: AmplifyAWSCredentials?

    init (isSignedIn: Bool, state: AuthUserState,
          userPoolTokens: CognitoUserPoolTokens,
          awsCredentials: AmplifyAWSCredentials?) {

        self.isSignedIn = isSignedIn
        self.state = state
        self.awsCredentials = awsCredentials
        self.userPoolTokens = userPoolTokens
    }
}

extension CognitoUserPoolAuthInformation: AmplifyAWSCredentialsProvider {

    public func getAWSCredentials() -> AmplifyAWSCredentials {
        return awsCredentials!
    }
}
