//
//  ComputerHistoryManager.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/14/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import Foundation
import Combine
import os.log

class ComputerHistoryCombine: ObservableObject, DirPickerData {
    
    var fileWriter:FileWriter = FileWriter()

    @Published var WorkingDir: URL?
    // checking if workingdir is nil in views causes access errors, so workaround is to check via this instead
    var directoryPicked : Bool {
        get {
            return Bool(WorkingDir == nil || computerHistoryArray.isEmpty)
        }
    }
    
    private var jamfURL = JamfURL()

    var baseURL: String
    var basicCreds: String
    var session: URLSession

    /**
     Set or get the advanced search ID, and collect the associated report and store the report count in advancedSearchReport
     */
    var advancedSearchID: String = ""{
        willSet(newValue){
            self.advancedSearchReport = "Loading"
            _ = self.ComputerSearch(searchID: newValue)
            { searchResult in
                guard let myCount = searchResult?.endIndex else {
                    DispatchQueue.main.async{
                        self.advancedSearchReport = "No Search Found"
                    }
                    return
                }
                DispatchQueue.main.async{
                    self.advancedSearchReport = String(myCount)
                }
            }
        }
    }
    @Published var advancedSearchReport: String = "No Search Found"
    @Published var computerHistoryArray: [ComputerHistory] = []
    
    /**
     Initialize the ComputerHistoryCombine
     
     - parameters:
        - baseURL: base url for use with all endpoints
        - basicCreds: base64 encoded basic credentials
        - session: Session to be used with requests
     */
    init(baseURL: String, basicCreds: String, session:URLSession){
        self.baseURL = baseURL
        self.basicCreds = basicCreds
        self.session = session
    }

    /**
     Save a sring to local workingDir with a given filename
     - returns:
     true for success, false for failure
     - parameters:
        - csvArray: An array of strings with each CSV
        - header: A string designating the headers of the CSV
        - fileName: Name of the file to be written
     */
    private func saveCSV(csvArray: [String],header:String,fileName:String) -> Bool{
        let catHist = csvArray.joined(separator: "\n")
        let csvWithHeader = "\(header)\n\(catHist)"
        guard let WorkingDir = WorkingDir else {
            os_log("No directory selected, cannot save file",log: .jamfAPI, type: .error)
            return false
        }
        guard (try? fileWriter.WriteStringDated(myString: csvWithHeader, saveDirectory: WorkingDir, fileName: fileName,fileType: ".csv")) != nil else {
            os_log("Could not save file, an unknown error occurred",log: .jamfAPI, type: .error)
            return false
        }
        return true
    }
    
    
    // TODO: Find a better way to write these function. This should be simplified, and instead pass parameters to a single function
    public func SaveComputerUsage() -> Bool{
        let header = ("id, name, udid, serialNumber, event, username, time")
        let csvHistoryArray: [String] = computerHistoryArray.map { "\($0.id), \($0.name), \($0.udid), \($0.serialNumber)\n\($0.compUsageCSV())" }
        let fileName = "ComputerUsageLogs"
        return saveCSV(csvArray: csvHistoryArray, header: header, fileName: fileName)
    }
    public func SaveAudits() -> Bool{
        let header = ("id, name, udid, serialNumber, event, username, time")
        let csvHistoryArray: [String] = computerHistoryArray.map { "\($0.id), \($0.name), \($0.udid), \($0.serialNumber)\n\($0.auditsCSV())" }
        let fileName = "AuditLogs"
        return saveCSV(csvArray: csvHistoryArray, header: header, fileName: fileName)
    }
    public func SavePolicyLogs() -> Bool{
        let header = ("id, name, udid, serialNumber, event, username, time")
        let csvHistoryArray: [String] = computerHistoryArray.map { "\($0.id), \($0.name), \($0.udid), \($0.serialNumber)\n\($0.policyLogCSV())" }
        let fileName = "policyLogs"
        return saveCSV(csvArray: csvHistoryArray, header: header, fileName: fileName)
    }
    public func SaveRemoteLogs() -> Bool{
        let header = ("id, name, udid, serialNumber, event, username, time")
        let csvHistoryArray: [String] = computerHistoryArray.map { "\($0.id), \($0.name), \($0.udid), \($0.serialNumber)\n\($0.remoteLogCSV())" }
        let fileName = "RemoteLogs"
        return saveCSV(csvArray: csvHistoryArray, header: header, fileName: fileName)
    }
    public func SaveSharingLogs() -> Bool{
        let header = ("id, name, udid, serialNumber, event, username, time")
        let csvHistoryArray: [String] = computerHistoryArray.map { "\($0.id), \($0.name), \($0.udid), \($0.serialNumber)\n\($0.screenShareLogCSV())" }
        let fileName = "ScreenSharingLogs"
        return saveCSV(csvArray: csvHistoryArray, header: header, fileName: fileName)
    }
    public func SaveImagingLogs() -> Bool{
        let header = ("id, name, udid, serialNumber, event, username, time")
        let csvHistoryArray: [String] = computerHistoryArray.map { "\($0.id), \($0.name), \($0.udid), \($0.serialNumber)\n\($0.casperImageCSV())" }
        let fileName = "ImagingLogs"
        return saveCSV(csvArray: csvHistoryArray, header: header, fileName: fileName)
    }
    public func SaveCommandLogs() -> Bool{
        let header = ("id, name, udid, serialNumber, event, username, time")
        let csvHistoryArray: [String] = computerHistoryArray.map { "\($0.id), \($0.name), \($0.udid), \($0.serialNumber)\n\($0.commandsCSV())" }
        let fileName = "CommandLogs"
        return saveCSV(csvArray: csvHistoryArray, header: header, fileName: fileName)
    }
    public func SaveUserLocationLogs() -> Bool{
        let header = ("id, name, udid, serialNumber, event, username, time")
        let csvHistoryArray: [String] = computerHistoryArray.map { "\($0.id), \($0.name), \($0.udid), \($0.serialNumber)\n\($0.userLocationCSV())" }
        let fileName = "UserLocationLogs"
        return saveCSV(csvArray: csvHistoryArray, header: header, fileName: fileName)
    }
    public func SaveMacAppStoreAppLogs() -> Bool{
        let header = ("id, name, udid, serialNumber, event, username, time")
        let csvHistoryArray: [String] = computerHistoryArray.map { "\($0.id), \($0.name), \($0.udid), \($0.serialNumber)\n\($0.macAppLogCSV())" }
        let fileName = "MacAppStoreLogs"
        return saveCSV(csvArray: csvHistoryArray, header: header, fileName: fileName)
    }
    
    /**
     Run a computer search by id, escaping an array of results
     
     - returns: a URLSessionDataTask? for the search
     - parameters:
        - searchID: The id of the search to be used with the computer search endpoint
     */
    public func ComputerSearch(searchID:String, searchResArray: @escaping ([SearchResult]?) -> Void) -> URLSessionDataTask?
    {
        guard let myURL = jamfURL.BuildJamfURL(baseURL:baseURL, endpoint: CAPIEndpoints.advancedComputerSearches, identifierType: IdentifierType.id, identifier: searchID) else {
            os_log("No url was passed, something went wrong",log: .jamfAPI, type: .error)
            return nil
        }
        let myRequest = URLRequest(url: myURL,basicCredentials:basicCreds, method: HTTPMethod.get,accept: ContentType.json)
        
        let search = AdvancedComputerSearch.SearchRequest(request: myRequest, session: session){advancedSearch in
            searchResArray(advancedSearch?.results)
        }
        return search
    }
    
    /**
     Get an array of computer histories from an array of computer history id's
     
     - returns: An array of URLSessionDataTask
     - parameters:
        - idArray: An array of id's to be used with the computer history endpoint
     */
    public func ComputerHistoryArray(idArray: [String], historyArray: @escaping ([ComputerHistory]) -> Void) -> [URLSessionDataTask]{
        var requestArray: [URLRequest] = []
        for id in idArray {
            if let myURL = jamfURL.BuildJamfURL(baseURL: baseURL, endpoint: CAPIEndpoints.computerHistory, identifierType: IdentifierType.id, identifier: id){
                let myRequest = URLRequest(url:myURL,basicCredentials:basicCreds, method: HTTPMethod.get, accept: ContentType.json)
                requestArray.append(myRequest)
            }
            else{
                os_log("an unknown error occurred, history will not be collected",log: .jamfAPI, type: .error)
            }
        }
        let taskArray = ComputerHistory.HistoryRequestArray(requestArray:requestArray,session:session){myArray in
            historyArray(myArray)
        }
        return taskArray
    }
    
    /**
     Set variable for computerHistoryArray to an array of computer histories collected from a search id
     - parameters:
        - searchID: The id of the search to collect computer histories from
     */
    public func SetComputerHistoryFromSearchID(searchID: String, retHistoryArray: @escaping ([ComputerHistory]) -> Void) {
        DispatchQueue.global().async
            {
                let group = DispatchGroup()
                var compIDs: [String] = []
                group.enter()
                _ = self.ComputerSearch(searchID:searchID){
                    searchResults in
                    guard let searchResults = searchResults else {
                        os_log("No search result found, no history will be collected",log: .jamfAPI, type: .info)
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
                        self.computerHistoryArray = compHistoryArray
                        retHistoryArray(compHistoryArray)
                    }

                }
        }
    }
}
