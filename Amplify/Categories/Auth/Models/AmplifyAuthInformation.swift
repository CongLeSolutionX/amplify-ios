//
// Copyright 2018-2020 Amazon.com,
// Inc. or its affiliates. All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

public protocol AmplifyAuthInformation {

    var isSignedIn: Bool { get }

    var state: AuthUserState { get }
}

public protocol AmplifyAWSCredentialsProvider {

    func getAWSCredentials() -> AmplifyAWSCredentials
}

public protocol AmplifyAWSCredentials {

    var  accessKey: String { get }

    var secretKey: String { get }

    var sessionKey: String { get }

    var expiration: Date { get }
}
