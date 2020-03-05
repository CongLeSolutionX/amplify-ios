//
// Copyright 2018-2020 Amazon.com,
// Inc. or its affiliates. All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

public enum AmplifyAuthError {
    case authEroor(ErrorDescription, RecoverySuggestion, Error? = nil)
    case configuration(ErrorDescription, RecoverySuggestion, Error? = nil)
}

extension AmplifyAuthError: AmplifyError {


    public var underlyingError: Error? {
        return nil
    }

    public var errorDescription: ErrorDescription {
        return "Error"
    }

    public var recoverySuggestion: RecoverySuggestion {
        return "RecoverySuggestion"
    }
}
