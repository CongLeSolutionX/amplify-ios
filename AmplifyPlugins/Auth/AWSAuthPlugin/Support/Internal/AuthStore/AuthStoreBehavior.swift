//
//  AuthStoreBehavior.swift
//  AWSAuthPlugin
//
//  Created by Roy, Jithin on 3/24/20.
//  Copyright © 2020 Amazon Web Services. All rights reserved.
//

import Foundation

protocol AuthStoreBehavior {

    func getAuthInformation()
}

class AuthStoreInfo {

    let loginMaps: [String: String]? = nil

    let cognitoIdentityID: String? = nil

}

//extension AuthStoreInfo: NSSecureCoding {
//
//    static var supportsSecureCoding: Bool {
//        return true
//    }
//
//    func encode(with coder: NSCoder) {
//
//    }
//
//
//}

class CognitoUserPoolTokenInfo {

}

class AWSCredentialsInfo {
    
}
