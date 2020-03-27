//
//  CognitoUserPoolAuthInformation.swift
//  AWSAuthPlugin
//
//  Created by Roy, Jithin on 3/5/20.
//  Copyright © 2020 Amazon Web Services. All rights reserved.
//

import Amplify

public struct CognitoUserPoolAuthInformation: AmplifyAuthInformation {

    public var isSignedIn: Bool // method get the value from AuthUserState

    public var state: AuthUserState

    let awsCredentials: AmplifyAWSCredentials?

    let cognitoUserPoolTokens: CognitoUserPoolTokens

    init (isSignedIn: Bool,
          state: AuthUserState,
          userPoolTokens: CognitoUserPoolTokens,
          awsCredentials: AmplifyAWSCredentials?) {

        self.isSignedIn = isSignedIn
        self.state = state
        self.awsCredentials = awsCredentials
        self.cognitoUserPoolTokens = userPoolTokens
    }
}

extension CognitoUserPoolAuthInformation: AmplifyAWSCredentialsProvider {
    public var getAWSCredentials: AmplifyAWSCredentials {
        return awsCredentials!
    }
}

extension CognitoUserPoolAuthInformation: CognitoUserPoolTokensProvider {

    public var userPoolTokens: CognitoUserPoolTokens {
        return cognitoUserPoolTokens
    }


}
