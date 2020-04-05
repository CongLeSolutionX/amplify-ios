//
// Copyright 2018-2020 Amazon.com,
// Inc. or its affiliates. All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

public struct AuthConfirmSignUpRequest: AmplifyOperationRequest {

    public let username: String

    public let confirmationCode: String

    public var options: Options

    public init(username: String, confirmationCode: String, options: Options) {
        self.username = username
        self.confirmationCode = confirmationCode
        self.options = options
    }
}

public extension AuthConfirmSignUpRequest {

    struct Options {

        public let forceAliasCreation: Bool
        public let validationData: [String: String]?
        public let metaData: [String: String]?

        public init(forceAliasCreation: Bool = false,
                    validationData: [String: String]? = nil,
                    metaData: [String: String]? = nil) {
            self.forceAliasCreation = forceAliasCreation
            self.validationData = validationData
            self.metaData = metaData
        }
    }
}
