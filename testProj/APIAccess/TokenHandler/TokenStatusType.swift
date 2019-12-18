//
//  TokenStatusType.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/3/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

public enum TokenStatusType: Int{
    case valid = 0
    case sessionError = 1
    case requestError = 2
    case parseError = 3
    case unknown = 4
    case invalidated = 101
    case waiting = 100
    case loading = 102
}
