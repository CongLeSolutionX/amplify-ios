//
// Copyright 2018-2020 Amazon.com,
// Inc. or its affiliates. All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

public struct AuthCodeDeliveryDetails {

    public let desitination: String?

    public let deliveryMedium: DeliveryMedium

    public let attribuetName: String?

    public init(desitination: String?,
                 deliveryMedium: DeliveryMedium,
                 attribuetName: String?) {
        self.desitination = desitination
        self.deliveryMedium = deliveryMedium
        self.attribuetName = attribuetName
    }

}

//TODO: Should we move this under AuthCodeDeliveryDetails extension?
public enum DeliveryMedium {
    case sms
    case email
    case unknown
}
