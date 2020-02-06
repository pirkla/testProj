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
    
    @State var loadingReport: String = " "
    
    var body: some View {
        VStack {
            Text("History Report")
            TextField("Enter Search ID", text: $computerHistoryCombine.advancedSearchID).frame(width: 200, alignment: .center)
            HStack{
                Text("Computers In Search:")
                Text(computerHistoryCombine.advancedSearchReport)
            }
            
            Button(action: {
                self.loadingReport = "Loading Report"
                self.computerHistoryCombine.SetComputerHistoryFromSearchID(searchID: self.computerHistoryCombine.advancedSearchID){
                    historyArray in
                    self.loadingReport = " "
                }
            }) {
                Text("Run Report")
                
            }
            Text(loadingReport)
            VStack {
                ComputerHistoryList(listArray: computerHistoryCombine.computerHistoryArray)
            }.frame(width: 500, height: 100, alignment: .center)

            VStack{                DirPickerView(dirPickerData:computerHistoryCombine)
                if(computerHistoryCombine.directoryPicked){
                    Text("Run a report and choose a directory to save")
                }
                else {
                    Spacer()
                }
                HStack {
                    Button(action: {
                        _ = self.computerHistoryCombine.SaveComputerUsage()
                    }) {
                        Text("Save Computer Usage")
                    }.disabled(computerHistoryCombine.directoryPicked)
                    
                    Button(action: {
                        _ = self.computerHistoryCombine.SaveAudits()
                    }) {
                        Text("Save Audit Logs")
                    }.disabled(computerHistoryCombine.directoryPicked)
                    Button(action: {
                        _ = self.computerHistoryCombine.SavePolicyLogs()
                    }) {
                        Text("Save Policy Logs")
                    }.disabled(computerHistoryCombine.directoryPicked)
                }
                HStack {
                    Button(action: {
                        _ = self.computerHistoryCombine.SaveRemoteLogs()
                    }) {
                        Text("Save Remote Logs")
                    }.disabled(computerHistoryCombine.directoryPicked)
                    Button(action: {
                        _ = self.computerHistoryCombine.SaveSharingLogs()
                    }) {
                        Text("Save Screen Sharing Logs")
                    }.disabled(computerHistoryCombine.directoryPicked)
                    Button(action: {
                        _ = self.computerHistoryCombine.SaveImagingLogs()
                    }) {
                        Text("Save Imaging Logs")
                    }.disabled(computerHistoryCombine.directoryPicked)

                }
                HStack {
                    Button(action: {
                        _ = self.computerHistoryCombine.SaveCommandLogs()
                    }) {
                        Text("Save Command Logs")
                    }.disabled(computerHistoryCombine.directoryPicked)
                    Button(action: {
                        _ = self.computerHistoryCombine.SaveUserLocationLogs()
                    }) {
                        Text("Save User and Location Logs")
                    }.disabled(computerHistoryCombine.directoryPicked)
                    Button(action: {
                        _ = self.computerHistoryCombine.SaveMacAppStoreAppLogs()
                    }) {
                        Text("Save Mac App Store App Logs")
                    }.disabled(computerHistoryCombine.directoryPicked)
                }

                Spacer()
            }


        }
    }
}

struct HistoryReportView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryReportView(computerHistoryCombine: ComputerHistoryCombine(baseURL: "", basicCreds: "", session: SessionHandler.SharedSessionHandler.mySession))
    }
}
