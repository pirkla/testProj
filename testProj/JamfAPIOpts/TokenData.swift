//
//  APITokenData.swift
//  testProj
//
//  Created by Andrew Pirkl on 11/29/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import Foundation
struct TokenData{
    var token: String?
    var expiration: Date?
    var statusType: TokenStatusType
}

public enum TokenStatusType: Int{
    case valid = 0
    case sessionError = 1
    case requestError = 2
    case parseError = 3
    case unknown = 4
    case waiting = 100
}
