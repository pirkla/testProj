//
//  DirPickerData.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/15/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import Foundation
import Combine
protocol DirPickerData: ObservableObject {
    var WorkingDir: URL? {get set}
}
