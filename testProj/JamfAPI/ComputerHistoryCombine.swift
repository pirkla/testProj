//
//  ComputerHistoryManager.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/14/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import Foundation
import Combine
class ComputerHistoryCombine: ObservableObject, DirPickerData {
    
    var fileWriter:FileWriter = FileWriter()

    @Published var WorkingDir: URL?
    // checking if workingdir is nil in views causes access errors, so workaround is to check via this instead
    var DirectoryPicked : Bool {
        get {
            return Bool(WorkingDir == nil)
        }
    }
    
    private var jamfURL = JamfURL()

    var baseURL: String
    var basicCreds: String
    var session: URLSession
    
    var AdvancedSearchID: String = ""{
        willSet(newValue){
            _ = self.ComputerSearch(searchID: newValue)
            { searchResult in
                guard let myCount = searchResult?.endIndex else {
                    DispatchQueue.main.async{
                        self.AdvancedSearchReport = "No Search Found"
                    }
                    return
                }
                DispatchQueue.main.async{
                    self.AdvancedSearchReport = String(myCount)
                }
            }
        }
    }
    @Published var AdvancedSearchReport: String = "No Search Found"
    @Published var ComputerHistoryArray: [ComputerHistory] = []
    
    init(baseURL: String, basicCreds: String, session:URLSession){
        self.baseURL = baseURL
        self.basicCreds = basicCreds
        self.session = session
    }

    private func saveCSV(csvArray: [String],header:String,fileName:String){
        let catHist = csvArray.joined(separator: "\n")
        let csvWithHeader = "\(header)\n\(catHist)"
        print(catHist)
        guard let WorkingDir = WorkingDir else {
            print("No directory present, cannot save csv")
            return
        }
        fileWriter.WriteStringDated(myString: csvWithHeader, saveDirectory: WorkingDir, fileName: fileName,fileType: ".csv")
    }
    
    public func SaveComputerUsage(){
        let header = ("id, name, udid, serialNumber, event, username, time")
        let csvHistoryArray: [String] = ComputerHistoryArray.map { "\($0.id), \($0.name), \($0.udid), \($0.serialNumber)\n\($0.compUsageCSV())" }
        let fileName = "ComputerUsageLogs"
        saveCSV(csvArray: csvHistoryArray, header: header, fileName: fileName)
    }
    public func SaveAudits(){
        let header = ("id, name, udid, serialNumber, event, username, time")
        let csvHistoryArray: [String] = ComputerHistoryArray.map { "\($0.id), \($0.name), \($0.udid), \($0.serialNumber)\n\($0.auditsCSV())" }
        let fileName = "AuditLogs"
        saveCSV(csvArray: csvHistoryArray, header: header, fileName: fileName)
    }
    public func SavePolicyLogs(){
        let header = ("id, name, udid, serialNumber, event, username, time")
        let csvHistoryArray: [String] = ComputerHistoryArray.map { "\($0.id), \($0.name), \($0.udid), \($0.serialNumber)\n\($0.policyLogCSV())" }
        let fileName = "policyLogs"
        saveCSV(csvArray: csvHistoryArray, header: header, fileName: fileName)
    }
    public func SaveRemoteLogs(){
        let header = ("id, name, udid, serialNumber, event, username, time")
        let csvHistoryArray: [String] = ComputerHistoryArray.map { "\($0.id), \($0.name), \($0.udid), \($0.serialNumber)\n\($0.remoteLogCSV())" }
        let fileName = "RemoteLogs"
        saveCSV(csvArray: csvHistoryArray, header: header, fileName: fileName)
    }
    public func SaveSharingLogs(){
        let header = ("id, name, udid, serialNumber, event, username, time")
        let csvHistoryArray: [String] = ComputerHistoryArray.map { "\($0.id), \($0.name), \($0.udid), \($0.serialNumber)\n\($0.screenShareLogCSV())" }
        let fileName = "ScreenSharingLogs"
        saveCSV(csvArray: csvHistoryArray, header: header, fileName: fileName)
    }
    public func SaveImagingLogs(){
        let header = ("id, name, udid, serialNumber, event, username, time")
        let csvHistoryArray: [String] = ComputerHistoryArray.map { "\($0.id), \($0.name), \($0.udid), \($0.serialNumber)\n\($0.casperImageCSV())" }
        let fileName = "ImagingLogs"
        saveCSV(csvArray: csvHistoryArray, header: header, fileName: fileName)
    }
    public func SaveCommandLogs(){
        let header = ("id, name, udid, serialNumber, event, username, time")
        let csvHistoryArray: [String] = ComputerHistoryArray.map { "\($0.id), \($0.name), \($0.udid), \($0.serialNumber)\n\($0.commandsCSV())" }
        let fileName = "CommandLogs"
        saveCSV(csvArray: csvHistoryArray, header: header, fileName: fileName)
    }
    public func SaveUserLocationLogs(){
        let header = ("id, name, udid, serialNumber, event, username, time")
        let csvHistoryArray: [String] = ComputerHistoryArray.map { "\($0.id), \($0.name), \($0.udid), \($0.serialNumber)\n\($0.userLocationCSV())" }
        let fileName = "UserLocationLogs"
        saveCSV(csvArray: csvHistoryArray, header: header, fileName: fileName)
    }
    public func SaveMacAppStoreAppLogs(){
        let header = ("id, name, udid, serialNumber, event, username, time")
        let csvHistoryArray: [String] = ComputerHistoryArray.map { "\($0.id), \($0.name), \($0.udid), \($0.serialNumber)\n\($0.macAppLogCSV())" }
        let fileName = "MacAppStoreLogs"
        saveCSV(csvArray: csvHistoryArray, header: header, fileName: fileName)
    }
    
    public func ComputerSearch(searchID:String, searchResArray: @escaping ([SearchResult]?) -> Void) -> URLSessionDataTask?
    {
        guard let myURL = jamfURL.BuildJamfURL(baseURL:baseURL, endpoint: CAPIEndpoints.advancedComputerSearches, identifierType: IdentifierType.id, identifier: searchID) else {
            print("no url passed, something went wrong")
            return nil
        }
        let myRequest = URLRequest(url: myURL,basicCredentials:basicCreds, method: HTTPMethod.get,accept: ContentType.json)
        
        let search = AdvancedComputerSearch.SearchRequest(request: myRequest, session: session){advancedSearch in
            searchResArray(advancedSearch?.results)
        }
        return search
    }
    
    public func ComputerHistoryArray(idArray: [String], historyArray: @escaping ([ComputerHistory]) -> Void) -> [URLSessionDataTask]{
        var requestArray: [URLRequest] = []
        for id in idArray {
            if let myURL = jamfURL.BuildJamfURL(baseURL: baseURL, endpoint: CAPIEndpoints.computerHistory, identifierType: IdentifierType.id, identifier: id){
                print(myURL)
                let myRequest = URLRequest(url:myURL,basicCredentials:basicCreds, method: HTTPMethod.get, accept: ContentType.json)
                requestArray.append(myRequest)
            }
            else{
                print("well something broke, not sure what")
            }
        }
        let taskArray = ComputerHistory.HistoryRequestArray(requestArray:requestArray,session:session){myArray in
            historyArray(myArray)
            print(historyArray)
        }
        return taskArray
    }
    
    public func SetComputerHistoryFromSearchID(searchID: String, retHistoryArray: @escaping ([ComputerHistory]) -> Void) {
        DispatchQueue.global().async
            {
                let group = DispatchGroup()
                var compIDs: [String] = []
                group.enter()
                _ = self.ComputerSearch(searchID:searchID){
                    searchResults in
                    guard let searchResults = searchResults else {
                        print("no search results found")
                        retHistoryArray(Array())
                        return
                    }
                    for myResult in searchResults{
                        compIDs.append(String(myResult.id))
                    }
                    group.leave()
                }
                group.wait()

                _ = self.ComputerHistoryArray(idArray: compIDs) {
                    compHistoryArray in
                    DispatchQueue.main.async {
                        self.ComputerHistoryArray = compHistoryArray
                        retHistoryArray(compHistoryArray)
                    }

                }
        }
    }
}
