//
//  AuthEvent.swift
//  AWSAuthPlugin
//
//  Created by Roy, Jithin on 3/4/20.
//  Copyright © 2020 Amazon Web Services. All rights reserved.
//

import Amplify

enum AuthEvent<CompletedType, ErrorType: AmplifyError> {

    case completed(CompletedType)

    case failed(ErrorType)
}
