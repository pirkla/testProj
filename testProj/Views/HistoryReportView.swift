//
//  HistoryReportView.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/9/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import SwiftUI




struct HistoryReportView: View {
    
    @ObservedObject var computerHistoryCombine: ComputerHistoryCombine
    @ObservedObject var windowStateData: WindowStateData
    
    var body: some View {
        VStack {
            Text("History Report")
            TextField("Enter Search ID", text: $computerHistoryCombine.AdvancedSearchID)
            Text("Computers In Search")
            Text(computerHistoryCombine.AdvancedSearchReport)
            Button(action: {
                self.computerHistoryCombine.SetComputerHistoryFromSearchID(searchID: self.computerHistoryCombine.AdvancedSearchID){
                    historyArray in
                }
            }) {
                Text("Run Report")
            }
            
            DirPickerView(dirPickerData:computerHistoryCombine)
            
            HStack {
                Button(action: {
                    self.computerHistoryCombine.SaveComputerUsage()
                }) {
                    Text("Save Computer Usage")
                }.disabled(computerHistoryCombine.DirectoryPicked)
                
                Button(action: {
                    self.computerHistoryCombine.SaveAudits()
                }) {
                    Text("Save Audit Logs")
                }.disabled(computerHistoryCombine.DirectoryPicked)
                Button(action: {
                    self.computerHistoryCombine.SavePolicyLogs()
                }) {
                    Text("Save Policy Logs")
                }.disabled(computerHistoryCombine.DirectoryPicked)
            }
            HStack {
                Button(action: {
                    self.computerHistoryCombine.SaveRemoteLogs()
                }) {
                    Text("Save Remote Logs")
                }.disabled(computerHistoryCombine.DirectoryPicked)
                Button(action: {
                    self.computerHistoryCombine.SaveSharingLogs()
                }) {
                    Text("Save Screen Sharing Logs")
                }.disabled(computerHistoryCombine.DirectoryPicked)
                Button(action: {
                    self.computerHistoryCombine.SaveImagingLogs()
                }) {
                    Text("Save Imaging Logs")
                }.disabled(computerHistoryCombine.DirectoryPicked)

            }
            HStack {
                Button(action: {
                    self.computerHistoryCombine.SaveCommandLogs()
                }) {
                    Text("Save Command Logs")
                }.disabled(computerHistoryCombine.DirectoryPicked)
                Button(action: {
                    self.computerHistoryCombine.SaveUserLocationLogs()
                }) {
                    Text("Save User and Location Logs")
                }.disabled(computerHistoryCombine.DirectoryPicked)
                Button(action: {
                    self.computerHistoryCombine.SaveMacAppStoreAppLogs()
                }) {
                    Text("Save Mac App Store App Logs")
                }.disabled(computerHistoryCombine.DirectoryPicked)
            }
            VStack {
                Text("error placeholder")
                ComputerHistoryList(listArray: computerHistoryCombine.ComputerHistoryArray)
            }
        }
    }
}

struct HistoryReportView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryReportView(computerHistoryCombine: ComputerHistoryCombine(baseURL: "", basicCreds: "", session: SessionHandler.SharedSessionHandler.mySession),windowStateData: WindowStateData())
    }
}
