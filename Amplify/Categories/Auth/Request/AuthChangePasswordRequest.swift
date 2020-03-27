//
// Copyright 2018-2020 Amazon.com,
// Inc. or its affiliates. All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

public struct AuthChangePasswordRequest: AmplifyOperationRequest {

    public let currentPassword: String

    public let newPassword: String

    public var options: Options

    public init(currentPassword: String,
                newPassword: String,
                options: Options) {
        self.currentPassword = currentPassword
        self.newPassword = newPassword
        self.options = options
    }
}

public extension AuthChangePasswordRequest {

    struct Options {

        public let metaData: [String: String]?

        public init(metaData: [String: String]? = nil) {
            self.metaData = metaData
        }
    }
}
