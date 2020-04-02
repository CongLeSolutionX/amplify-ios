//
// Copyright 2018-2020 Amazon.com,
// Inc. or its affiliates. All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import UIKit

public typealias AuthUIPresentationAnchor = UIWindow

public struct AuthUISignInRequest: AmplifyOperationRequest {

    public var options: Options

    public init( options: Options) {

        self.options = options
    }
}

public extension AuthUISignInRequest {

    struct Options {
        public var presentationAnchor: AuthUIPresentationAnchor?
        public let validationData: [String: String]?
        public let metaData: [String: String]?

        public init(presentationAnchor: AuthUIPresentationAnchor? = nil,
                    validationData: [String: String]? = nil,
                    metaData: [String: String]? = nil) {
            self.presentationAnchor = presentationAnchor
            self.validationData = validationData
            self.metaData = metaData
        }
    }
}
