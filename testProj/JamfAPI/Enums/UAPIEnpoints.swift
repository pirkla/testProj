//
//  Enpoints.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/5/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import Foundation
// should really have used url components for this

public enum UAPIEndpoints {
    static let authKeepAlive = "/uapi/auth/keepAlive"
    static let authInvalidate = "/uapi/auth/invalidateToken"
    static let authToken = "/uapi/auth/tokens"
    static let authCurrent = "/uapi/auth/current"
}
