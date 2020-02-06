//
//  OSLogExtension.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/17/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import Foundation
import os.log

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let serialization = OSLog(subsystem: subsystem, category: "serialization")
    static let ui = OSLog(subsystem: subsystem, category: "ui")
    static let network = OSLog(subsystem: subsystem, category: "network")
    static let api = OSLog(subsystem: subsystem, category: "api")
    static let tokenManager = OSLog(subsystem: subsystem, category: "tokenManager")
    static let jamfAPI = OSLog(subsystem: subsystem, category: "jamfAPI")
    
}
