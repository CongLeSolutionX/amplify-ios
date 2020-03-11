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

public protocol CognitoUserPoolTokens {

    var idToken: String { get }
    var accessToken: String { get }
    var refreshToken: String { get }
    var expiration: Date { get }
    
}
