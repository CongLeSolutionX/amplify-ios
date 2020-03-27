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
