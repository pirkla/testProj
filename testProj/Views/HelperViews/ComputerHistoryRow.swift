
//
//  ComputerHistoryRow.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/11/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import SwiftUI

struct ComputerHistoryRow: View {
    var computerHistory: ComputerHistory
    var body: some View {
        HStack {
            Text(computerHistory.name)
            Text(computerHistory.serialNumber)
        }
    }
}

//struct ComputerHistoryRow_Previews: PreviewProvider {
//    static var previews: some View {
////        ComputerHistoryRow(computerHistory: ComputerHistory())
//    }
//}
