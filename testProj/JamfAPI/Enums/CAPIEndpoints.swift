//
//  CAPIEndpoints.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/5/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import Foundation
// should really have used url components for this
public enum CAPIEndpoints {
    static let computers = "/JSSResource/computers"
    static let computersEA = "/JSSResource/computers/extensionattributedataflush"
    static let advancedComputerSearches = "/JSSResource/advancedcomputersearches"
    static let computerHistory = "/JSSResource/computerhistory"
}