//
//  ComputerHistoryList.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/11/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import SwiftUI

struct ComputerHistoryList: View {
    
    var listArray: [ComputerHistory] = []

    
    var body: some View {
        List(listArray, id: \.id) {
            computerHistory in
            ComputerHistoryRow(computerHistory: computerHistory)
        }
    }
}

struct ComputerHistoryList_Previews: PreviewProvider {
    static var previews: some View {
        ComputerHistoryList()
    }
}
