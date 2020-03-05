//
// Copyright 2018-2020 Amazon.com,
// Inc. or its affiliates. All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

public protocol AuthCategoryClientBehavior {

    func signUp(username: String,
                password: String,
                options: AuthSignUpOperation.Request.Options?,
                listener: AuthSignUpOperation.EventListener?) -> AuthSignUpOperation
}
