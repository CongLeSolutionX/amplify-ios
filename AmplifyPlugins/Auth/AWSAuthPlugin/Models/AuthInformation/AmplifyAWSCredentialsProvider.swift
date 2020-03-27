//
//  AmplifyAWSCredentialsProvider.swift
//  AWSAuthPlugin
//
//  Created by Roy, Jithin on 3/24/20.
//  Copyright © 2020 Amazon Web Services. All rights reserved.
//

import Foundation

public protocol AmplifyAWSCredentialsProvider {

    var getAWSCredentials: AmplifyAWSCredentials { get }
}

public struct AmplifyAWSCredentials {

    public let accessKey: String
    public let secretKey: String
    public let sessionKey: String
    public let expiration: Date

    public func isValid() -> Bool {
        return true
    }
}
