//
//  CognitoUserPoolTokens.swift
//  AWSAuthPlugin
//
//  Created by Roy, Jithin on 3/9/20.
//  Copyright © 2020 Amazon Web Services. All rights reserved.
//

import Foundation

public protocol CognitoUserPoolTokensProvider {

    var userPoolTokens: CognitoUserPoolTokens { get }
}

public struct CognitoUserPoolTokens {

    public let idToken: String
    public let accessToken: String
    public let refreshToken: String
    public let expiration: Date

    public func isValid() -> Bool {
        return true
    }
}
