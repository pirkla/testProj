//
//  PickerView.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/30/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import SwiftUI

struct PickerView: View {
    @ObservedObject var windowStateData: WindowStateData
    @ObservedObject var jamfAPIAccess: JamfAPIAccess

    
    
    var body: some View {
        VStack {
            NavigationView {
                List()
                    {
                        NavigationLink(destination: HistoryReportView(computerHistoryCombine: ComputerHistoryCombine(baseURL: jamfAPIAccess.BaseURL, basicCreds: jamfAPIAccess.basicCreds, session:SessionHandler.SharedSessionHandler.mySession))) { Text("Computer History Report") }
                        NavigationLink(destination: PrinterView(printerCombine: PrinterCombine(baseURL: jamfAPIAccess.BaseURL, basicCreds: jamfAPIAccess.basicCreds, session:SessionHandler.SharedSessionHandler.mySession))) { Text("Printer Management") }
                }.listStyle(SidebarListStyle())
            }
        }
    }
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        PickerView(windowStateData: WindowStateData(), jamfAPIAccess: JamfAPIAccess())
    }
}
