//
//  ComputerHistory.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/7/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import Foundation
struct ComputerHistory {
    var id: Int
    var name: String
    var udid: String
    var serialNumber: String
    var computerUsageLogs: [EventLog]
    var audits: [EventLog]
    var policyLogs: [PolicyLogs]
    var casperRemoteLogs: [GenericLog]
    var screenSharingLogs: [GenericLog]
    var casperImagingLogs: [GenericLog]
    var commands: Commands
    var userLocations: [UserLocation]
    var macAppStoreApps: MacAppStoreApps
    
}
extension ComputerHistory{
    
    private func eventLogCSV(compHistory: ComputerHistory, logs: [EventLog]) -> String{
        var eventString: [String] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        
        for event in logs {
            let localTime = dateFormatter.string(from: event.time)
            eventString.append("\(compHistory.id), \(compHistory.name), \(compHistory.udid), \(compHistory.serialNumber), \(event.event), \(event.username), \(localTime)")
        }
        return eventString.joined(separator: "\n")
    }
    
    public func compUsageCSV() -> String {
        eventLogCSV(compHistory: self, logs: self.computerUsageLogs)
    }
    
    public func auditsCSV() -> String {
        eventLogCSV(compHistory: self, logs: self.audits)
    }
    
    public func policyLogCSV() -> String {
        var eventString: [String] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        
        for event in self.policyLogs {
            let localTime = dateFormatter.string(from: event.time)
            eventString.append("\(self.id), \(self.name), \(self.udid), \(self.serialNumber), \(event.id), \(event.name),\(event.username), \(localTime), \(event.status)")
        }
        return eventString.joined(separator: "\n")
    }
    
    private func genericLogCSV(compHistory:ComputerHistory, log: [GenericLog]) -> String {
            var eventString: [String] = []
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
            
            for event in log {
                let localTime = dateFormatter.string(from: event.time)
                eventString.append("\(compHistory.id), \(compHistory.name), \(compHistory.udid), \(compHistory.serialNumber), \(localTime), \(event.status)")
            }
            return eventString.joined(separator: "\n")
    }
    
    public func remoteLogCSV() -> String {
        return genericLogCSV(compHistory: self, log: self.casperRemoteLogs)
    }
    public func screenShareLogCSV() -> String {
        return genericLogCSV(compHistory: self, log: self.screenSharingLogs)
    }
    public func casperImageCSV() -> String {
        return genericLogCSV(compHistory: self, log: self.casperImagingLogs)
    }
    
    public func commandsCSV() -> String {
        var eventString: [String] = []

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        
        for event in self.commands.completedCommands{
            let localTime = dateFormatter.string(from: event.time)
            eventString.append("\(self.id), \(self.name), \(self.udid), \(self.serialNumber), \(event.name), \(localTime), \(event.username)")
        }
        for event in self.commands.pendingCommands{
            let issued = dateFormatter.string(from: event.issuedTime)
            let lastPush = dateFormatter.string(from: event.lastPush)
            eventString.append("\(self.id), \(self.name), \(self.udid), \(self.serialNumber), \(event.name), \(event.status),\(issued),\(lastPush), \(event.username)")
        }
        for event in self.commands.failedCommands{
            let issued = dateFormatter.string(from: event.issuedTime)
            let failed = dateFormatter.string(from: event.failedTime)
            eventString.append("\(self.id), \(self.name), \(self.udid), \(self.serialNumber), \(event.name), \(event.status),\(issued),\(failed)")
        }
        return eventString.joined(separator: "\n")
    }
    
    public func userLocationCSV()-> String{
        var eventString: [String] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        
        for event in self.userLocations {
            let localTime = dateFormatter.string(from: event.time)
            eventString.append("\(self.id), \(self.name), \(self.udid), \(self.serialNumber), \(localTime), \(event.username),\(event.fullName), \(event.emailAddress), \(event.phoneNumber), \(event.department), \(event.building), \(event.room), \(event.position)")
        }
        return eventString.joined(separator: "\n")
    }
    
    public func macAppLogCSV() -> String{
        var eventString: [String] = []

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"

        for event in self.macAppStoreApps.installedAppStore {
            eventString.append("\(self.id), \(self.name), \(self.udid), \(self.serialNumber), \(event.name), \(event.version), \(event.size)")
        }
        for event in self.macAppStoreApps.pendingAppStore{
            let deployedTime = dateFormatter.string(from: event.deployedTime)
            let lastUpdateTime = dateFormatter.string(from: event.lastUpdateTime)
            eventString.append("\(self.id), \(self.name), \(self.udid), \(self.serialNumber), \(event.name), \(event.version),\(deployedTime),\(lastUpdateTime)")
        }
        for event in self.macAppStoreApps.failedAppStore{
            let deployedTime = dateFormatter.string(from: event.deployedTime)
            let lastUpdateTime = dateFormatter.string(from: event.lastUpdateTime)
            eventString.append("\(self.id), \(self.name), \(self.udid), \(self.serialNumber), \(event.name), \(event.version), \(event.status),\(deployedTime),\(lastUpdateTime)")
        }
        return eventString.joined(separator: "\n")
    }
    
    
    
    
    
    init(json: [String: Any]) throws {
        print("starting")
        guard let historyDict = json["computer_history"] as? [String:Any] else {
            throw SerializationError.missing("computer_history")
        }
        // general section
        guard let general = historyDict["general"] as? [String:Any] else {
            throw SerializationError.missing("general")
        }
        guard let id = general["id"] as? Int else {
            throw SerializationError.missing("id")
        }
        guard let name = general["name"] as? String else {
            throw SerializationError.missing("name")
        }
        guard let udid = general["udid"] as? String else {
            throw SerializationError.missing("udid")
        }
        guard let serialNumber = general["serial_number"] as? String else{
            throw SerializationError.missing("serial_number")
        }
        
        //usage logs
        guard let usageLogDict = historyDict["computer_usage_logs"] as? [[String:Any]] else {
            throw SerializationError.missing("computer_usage_logs")
        }
        var computerUsageLogs: [EventLog]=[]
        for usageLog in usageLogDict {
            if let myLog = try? EventLog(json:usageLog){
                computerUsageLogs.append(myLog)
            }
        }
        
        //audit logs
        guard let auditDict = historyDict["audits"] as? [[String:Any]] else {
            throw SerializationError.missing("audits")
        }
        var audits: [EventLog]=[]
        for audit in auditDict {
            if let myLog = try? EventLog(json:audit){
                audits.append(myLog)
            }
        }
        
        // policy logs
        guard let policyDict = historyDict["policy_logs"] as? [[String:Any]] else {
            throw SerializationError.missing("policy_logs")
        }
        var policyLogs: [PolicyLogs]=[]
        for log in policyDict {
            if let myLog = try? PolicyLogs(json:log){
                policyLogs.append(myLog)
            }
        }
        
        // casper remote logs
        // needs verification
        guard let casperRemoteDict = historyDict["casper_remote_logs"] as? [[String:Any]] else {
            throw SerializationError.missing("casper_remote_logs")
        }
        var casperRemoteLogs: [GenericLog]=[]
        for log in casperRemoteDict {
            if let myLog = try? GenericLog(json:log){
                casperRemoteLogs.append(myLog)
            }
        }
        
        // screensharing logs
        // needs verification
        guard let screenSharingDict = historyDict["screen_sharing_logs"] as? [[String:Any]] else {
            throw SerializationError.missing("screen_sharing_logs")
        }
        var screenSharingLogs: [GenericLog]=[]
        for log in screenSharingDict {
            if let myLog = try? GenericLog(json:log){
                screenSharingLogs.append(myLog)
            }
        }
        
        // imaging logs
        // needs verification
        guard let casperImagingDict = historyDict["casper_imaging_logs"] as? [[String:Any]] else {
            throw SerializationError.missing("casper_imaging_logs")
        }
        var casperImagingLogs: [GenericLog]=[]
        for log in casperImagingDict {
            if let myLog = try? GenericLog(json:log){
                casperImagingLogs.append(myLog)
            }
        }
        
        // command logs
        // needs verification
        guard let commandsDict = historyDict["commands"] as? [String:Any] else {
            throw SerializationError.missing("commands")
        }
        guard let commands = try? Commands(json:commandsDict) else {
            throw SerializationError.missing("commandsDict")
        }
        
        // user location logs
        guard let userLocDict = historyDict["user_location"] as? [[String:Any]] else {
            throw SerializationError.missing("user_location")
        }
        var userLocations: [UserLocation]=[]
        for log in userLocDict {
            if let myLog = try? UserLocation(json:log){
                userLocations.append(myLog)
            }
        }
        
        
        // mac app store logs
        // needs verification
        guard let applicationsDict = historyDict["mac_app_store_applications"] as? [String:Any] else {
            throw SerializationError.missing("mac_app_store_applications")
        }
        guard let macAppStoreApps = try? MacAppStoreApps(json:applicationsDict) else {
            throw SerializationError.missing("applicationsDict")
        }
        
        
        self.id = id
        self.name = name
        self.udid = udid
        self.serialNumber = serialNumber
        self.computerUsageLogs = computerUsageLogs
        self.audits = audits
        self.policyLogs = policyLogs
        self.casperRemoteLogs = casperRemoteLogs
        self.screenSharingLogs = screenSharingLogs
        self.casperImagingLogs = casperImagingLogs
        self.commands = commands
        self.userLocations = userLocations
        self.macAppStoreApps = macAppStoreApps
    }
    
    
    static func HistoryRequest(request: URLRequest, session: URLSession, completion: @escaping (ComputerHistory?) -> Void) -> URLSessionDataTask {
        let dataTask = session.dataTask(request: request){
            (result) in
            switch result {
            case .success(let data):
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = json as? [String: Any] {
                    let parsed = try? ComputerHistory.init(json: dictionary)
                    if let parsed = parsed {
                        completion(parsed)
                        print("collected history")
                    }
                    else {
                        completion(nil)
                        print("history collection failed")
                    }
                }
                else {
                    completion(nil)
                    print("history collection failed")
                }
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
        dataTask.resume()
        return dataTask
    }
    
    static func HistoryRequestArray(requestArray: [URLRequest], session: URLSession, completion: @escaping ([ComputerHistory]) -> Void) -> [URLSessionDataTask] {
        var historyArray: [ComputerHistory] = []
        let dataTaskArray = session.dataTaskArray(requestArray:requestArray){resultArray in
            for result in resultArray{
                switch result {
                case .success(let data):
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let dictionary = json as? [String: Any] {
                        let parsed = try? ComputerHistory.init(json: dictionary)
                        if let parsed = parsed {
                            historyArray.append(parsed)
                            print("collected history")
                        }
                        else {
                            print("history collection failed")
                        }
                    }
                    else {
                        print("history collection failed")
                    }
                case .failure(let error):
                    print(error)
                }
            }
            completion(historyArray)
        }
        return dataTaskArray
    }
}
