//
// Copyright 2018-2020 Amazon.com,
// Inc. or its affiliates. All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

public struct AuthSignUpRequest: AmplifyOperationRequest {

    public let username: String

    public let password: String

    public var options: Options
}

public extension AuthSignUpRequest {

    struct Options {

        public let userAttributes: [String: String]?
        public let validationData: [String: String]?
        public let metaData: [String: String]?

        public init(userAttributes: [String: String]? = nil,
                    validationData: [String: String]? = nil,
                    metaData: [String: String]? = nil) {
            self.userAttributes = userAttributes
            self.validationData = validationData
            self.metaData = metaData
        }
    }
}
