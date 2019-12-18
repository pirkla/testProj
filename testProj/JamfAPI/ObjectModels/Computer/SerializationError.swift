//
//  SerializationError.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/7/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import Foundation

enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}
