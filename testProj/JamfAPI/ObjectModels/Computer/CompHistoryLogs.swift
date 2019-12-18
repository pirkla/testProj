//
//  CompHistoryLogs.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/7/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import Foundation

struct EventLog{
    var event: String
    var username: String
    var time: Date
}
extension EventLog {
    init(json: [String: Any]) throws {
        guard let event = json["event"] as? String else {
            throw SerializationError.missing("event")
        }
        guard let username = json["username"] as? String else {
            throw SerializationError.missing("username")
        }
        guard let epoch = json["date_time_epoch"] as? Double else {
            throw SerializationError.missing("date_time_epoch")
        }
        let time = Date(timeIntervalSince1970: epoch/1000)

        self.event = event
        self.username = username
        self.time = time
    }
}

struct PolicyLogs{
    var id: Int
    var name: String
    var username: String
    var time: Date
    var status: String
}
extension PolicyLogs {
    init(json: [String: Any]) throws {
        guard let id = json["policy_id"] as? Int else {
            throw SerializationError.missing("policy_id")
        }
        guard let name = json["policy_name"] as? String else {
            throw SerializationError.missing("policy_name")
        }
        guard let username = json["username"] as? String else {
            throw SerializationError.missing("username")
        }
        // this could be wrong on some version, some say date_time_epoch
        guard let epoch = json["date_completed_epoch"] as? Double else {
            throw SerializationError.missing("date_completed_epoch")
        }
        let time = Date(timeIntervalSince1970: epoch/1000)
        
        guard let status = json["status"] as? String else {
            throw SerializationError.missing("status")
        }

        self.id = id
        self.name = name
        self.username = username
        self.time = time
        self.status = status
    }
}


struct GenericLog{
    var time: Date
    var status: String
}
extension GenericLog{
    init(json: [String: Any]) throws {
        guard let epoch = json["date_time_epoch"] as? Double else {
            throw SerializationError.missing("date_time_epoch")
        }
        let time = Date(timeIntervalSince1970: epoch/1000)
        
        guard let status = json["status"] as? String else {
            throw SerializationError.missing("status")
        }
        self.time = time
        self.status = status
    }
}


struct CompletedCommand{
    var name: String
    var time: Date
    var username: String
}
extension CompletedCommand{
    init(json: [String: Any]) throws {
        guard let name = json["name"] as? String else {
            throw SerializationError.missing("name")
        }
        guard let epoch = json["completed_epoch"] as? Double else {
            throw SerializationError.missing("completed_epoch")
        }
        let time = Date(timeIntervalSince1970: epoch/1000)
        
        guard let username = json["username"] as? String else {
            throw SerializationError.missing("username")
        }
        
        self.name = name
        self.time = time
        self.username = username
    }
}



struct FailedCommand{
    var name: String
    var status: String
    var issuedTime: Date
    var failedTime: Date
}
extension FailedCommand{
    init(json: [String: Any]) throws {
        guard let name = json["name"] as? String else {
            throw SerializationError.missing("name")
        }
        guard let status = json["status"] as? String else {
            throw SerializationError.missing("status")
        }
        guard let issuedEpoch = json["issued_epoch"] as? Double else {
            throw SerializationError.missing("issued_epoch")
        }
        let issuedTime = Date(timeIntervalSince1970: issuedEpoch/1000)
        
        guard let failedEpoch = json["failed_epoch"] as? Double else {
            throw SerializationError.missing("failed_epoch")
        }
        let failedTime = Date(timeIntervalSince1970: failedEpoch/1000)

        self.name = name
        self.status = status
        self.issuedTime = issuedTime
        self.failedTime = failedTime
    }
}

struct PendingCommand{
    var name: String
    var status: String
    var issuedTime: Date
    var lastPush: Date
    var username: String
}
extension PendingCommand{
    init(json: [String: Any]) throws {
        guard let name = json["name"] as? String else {
            throw SerializationError.missing("name")
        }
        guard let status = json["status"] as? String else {
            throw SerializationError.missing("status")
        }
        guard let issuedEpoch = json["issued_epoch"] as? Double else {
            throw SerializationError.missing("issued_epoch")
        }
        let issuedTime = Date(timeIntervalSince1970: issuedEpoch/1000)
        
        guard let pushEpoch = json["last_push_epoch"] as? Double else {
            throw SerializationError.missing("last_push_epoch")
        }
        let lastPush = Date(timeIntervalSince1970: pushEpoch/1000)
        
        guard let username = json["username"] as? String else {
            throw SerializationError.missing("username")
        }

        self.name = name
        self.status = status
        self.issuedTime = issuedTime
        self.lastPush = lastPush
        self.username = username
    }
}

struct UserLocation{
    var time: Date
    var username: String
    var fullName: String
    var emailAddress: String
    var phoneNumber: String
    var department: String
    var building: String
    var room: String
    var position: String
}
extension UserLocation{
    init(json: [String: Any]) throws {
        guard let epoch = json["date_time_epoch"] as? Double else {
            throw SerializationError.missing("date_time_epoch")
        }
        let time = Date(timeIntervalSince1970: epoch/1000)
        
        guard let username = json["username"] as? String else {
            throw SerializationError.missing("username")
        }
        guard let fullName = json["full_name"] as? String else {
            throw SerializationError.missing("full_name")
        }
        guard let emailAddress = json["email_address"] as? String else {
            throw SerializationError.missing("email_address")
        }
        guard let phoneNumber = json["phone_number"] as? String else {
            throw SerializationError.missing("phone_number")
        }
        guard let department = json["department"] as? String else {
            throw SerializationError.missing("department")
        }
        guard let building = json["building"] as? String else {
            throw SerializationError.missing("building")
        }
        guard let room = json["room"] as? String else {
            throw SerializationError.missing("room")
        }
        guard let position = json["position"] as? String else {
            throw SerializationError.missing("position")
        }
    
        self.time = time
        self.username = username
        self.fullName = fullName
        self.emailAddress = emailAddress
        self.phoneNumber = phoneNumber
        self.department = department
        self.building = building
        self.room = room
        self.position = position
    }
}



struct InstalledAppStore{
    var name: String
    var version: String
    var size: Double
}
extension InstalledAppStore{
    init(json: [String: Any]) throws {
        guard let name = json["name"] as? String else {
            throw SerializationError.missing("name")
        }
        guard let version = json["version"] as? String else {
            throw SerializationError.missing("version")
        }
        guard let size = json["size_mb"] as? Double else {
            throw SerializationError.missing("size_mb")
        }
        self.name = name
        self.version = version
        self.size = size
    }
}


struct PendingAppStore{
    var name: String
    var version: String
    var deployedTime: Date
    var lastUpdateTime: Date
}
extension PendingAppStore{
    init(json: [String: Any]) throws {
        guard let name = json["name"] as? String else {
            throw SerializationError.missing("name")
        }
        guard let version = json["version"] as? String else {
            throw SerializationError.missing("version")
        }
        guard let deployedEpoch = json["deployed_epoch"] as? Double else {
            throw SerializationError.missing("deployed_epoch")
        }
        let deployedTime = Date(timeIntervalSince1970: deployedEpoch/1000)
        
        guard let lastUpdateEpoch = json["last_update_epoch"] as? Double else {
            throw SerializationError.missing("last_update_epoch")
        }
        let lastUpdateTime = Date(timeIntervalSince1970: lastUpdateEpoch/1000)
        
        self.name = name
        self.version = version
        self.deployedTime = deployedTime
        self.lastUpdateTime = lastUpdateTime
    }
}



struct FailedAppStore{
    var name: String
    var version: String
    var status: String
    var deployedTime: Date
    var lastUpdateTime: Date
}
extension FailedAppStore{
    init(json: [String: Any]) throws {
        guard let name = json["name"] as? String else {
            throw SerializationError.missing("name")
        }
        guard let version = json["version"] as? String else {
            throw SerializationError.missing("version")
        }
        guard let status = json["status"] as? String else {
        throw SerializationError.missing("status")
        }
        guard let deployedEpoch = json["deployed_epoch"] as? Double else {
            throw SerializationError.missing("deployed_epoch")
        }
        let deployedTime = Date(timeIntervalSince1970: deployedEpoch/1000)
        
        guard let lastUpdateEpoch = json["last_update_epoch"] as? Double else {
            throw SerializationError.missing("last_update_epoch")
        }
        let lastUpdateTime = Date(timeIntervalSince1970: lastUpdateEpoch/1000)
        
        self.name = name
        self.version = version
        self.status = status
        self.deployedTime = deployedTime
        self.lastUpdateTime = lastUpdateTime
    }
}

struct Commands{
    var completedCommands: [CompletedCommand]
    var pendingCommands: [PendingCommand]
    var failedCommands: [FailedCommand]
}
extension Commands{
    init(json: [String: Any]) throws {
        // completed commands
        guard let completedDict = json["completed"] as? [[String:Any]] else {
            throw SerializationError.missing("completed")
        }
        var completedCommands: [CompletedCommand]=[]
        for log in completedDict {
            if let myLog = try? CompletedCommand(json:log){
                completedCommands.append(myLog)
            }
        }
        
        // pending commands
        // needs verification
        guard let pendingDict = json["pending"] as? [[String:Any]] else {
            throw SerializationError.missing("pending")
        }
        var pendingCommands: [PendingCommand]=[]
        for log in pendingDict {
            if let myLog = try? PendingCommand(json:log){
                pendingCommands.append(myLog)
            }
        }
        
        // failed commands
        // needs verification
        guard let failedDict = json["failed"] as? [[String:Any]] else {
            throw SerializationError.missing("failed")
        }
        var failedCommands: [FailedCommand]=[]
        for log in failedDict {
            if let myLog = try? FailedCommand(json:log){
                failedCommands.append(myLog)
            }
        }
        self.completedCommands = completedCommands
        self.pendingCommands = pendingCommands
        self.failedCommands = failedCommands
    }
}


struct MacAppStoreApps{
    var installedAppStore: [InstalledAppStore]
    var pendingAppStore: [PendingAppStore]
    var failedAppStore: [FailedAppStore]
}
extension MacAppStoreApps{
    init(json: [String: Any]) throws {
        // installed apps
        guard let installedDict = json["installed"] as? [[String:Any]] else {
            throw SerializationError.missing("installed")
        }
        var installedAppStore: [InstalledAppStore]=[]
        for log in installedDict {
            if let myLog = try? InstalledAppStore(json:log){
                installedAppStore.append(myLog)
            }
        }
        
        // pending apps
        // needs verification
        guard let appStorePendingDict = json["pending"] as? [[String:Any]] else {
            throw SerializationError.missing("pending")
        }
        var pendingAppStore: [PendingAppStore]=[]
        for log in appStorePendingDict {
            if let myLog = try? PendingAppStore(json:log){
                pendingAppStore.append(myLog)
            }
        }
        
        // failed apps
        // needs verification
        guard let appStoreFailedDict = json["failed"] as? [[String:Any]] else {
            throw SerializationError.missing("failed")
        }
        var failedAppStore: [FailedAppStore]=[]
        for log in appStoreFailedDict {
            if let myLog = try? FailedAppStore(json:log){
                failedAppStore.append(myLog)
            }
        }
        
        self.installedAppStore = installedAppStore
        self.pendingAppStore = pendingAppStore
        self.failedAppStore = failedAppStore
    }
}
