//
//  AWSAuthConfiguration.swift
//  AWSAuthPlugin
//
//  Created by Roy, Jithin on 3/25/20.
//  Copyright © 2020 Amazon Web Services. All rights reserved.
//

import AWSCore

struct AWSAuthConfiguration {
    let region: AWSRegionType

    let identityPoolId: String

    let userPoolId: String
    let userPoolAppClientId: String
    let userPoolAppClientSecret: String

    let authenticationFlowType: String
    let userPoolHostedUIDomain: String

    let signInRedirectURI: String
    let signOutRedirectURI: String

    let hostedUIScopes: [String]
}

extension AWSAuthConfiguration: Decodable {

    enum CodingKeys: String, CodingKey {
        case region
        case identityPoolId

        case userPoolId
        case userPoolAppClientId
        case userPoolAppClientSecret

        case authenticationFlowType
        case userPoolHostedUIDomain

        case signInRedirectURI
        case signOutRedirectURI

        case hostedUIScopes
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let regionString = try values.decode(String.self, forKey: .region) as NSString

        region = regionString.aws_regionTypeValue()
        identityPoolId = try values.decode(String.self, forKey: .identityPoolId)
        userPoolId = try values.decode(String.self, forKey: .userPoolId)
        userPoolAppClientId = try values.decode(String.self, forKey: .userPoolAppClientId)
        userPoolAppClientSecret = try values.decode(String.self, forKey: .userPoolAppClientSecret)
        authenticationFlowType = try values.decode(String.self, forKey: .authenticationFlowType)
        userPoolHostedUIDomain = try values.decode(String.self, forKey: .userPoolHostedUIDomain)
        signInRedirectURI = try values.decode(String.self, forKey: .signInRedirectURI)
        signOutRedirectURI = try values.decode(String.self, forKey: .signOutRedirectURI)
        hostedUIScopes = try values.decode(Array.self, forKey: .hostedUIScopes)
    }
}
