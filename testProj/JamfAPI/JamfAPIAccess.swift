//
//  JamfAPIAccess.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/6/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import Foundation
import Combine
import os.log

class JamfAPIAccess: ObservableObject {
    
    let objectWillChange = PassthroughSubject<JamfAPIAccess,Never>()
    
    
    @Published var BaseURL: String = "" {
        willSet(newValue) { objectWillChange.send(self)
        }
    }
    @Published var Username: String = ""{
        willSet(newValue) { objectWillChange.send(self)
        }
    }
    @Published var Password: String = ""{
        willSet(newValue) { objectWillChange.send(self)
        }
    }
    
    /**
     Set trust for the global session handler. Note this changes trust for pending and future requests.
     */
    @Published var allowUntrusted: Bool = false{
        willSet(newValue) {objectWillChange.send(self)
            SessionHandler.SharedSessionHandler.setAllowUntrusted(allowUntrusted: newValue)
        }
    }
    
    /**
     Access the used token manager instance
     */
    public private(set) var apiTokenManager: APITokenManager = APITokenManager()
    
    private var session = SessionHandler.SharedSessionHandler.mySession
    private var jamfURL = JamfURL()
    
    public var basicCreds : String {
        get {
            return String("\(Username):\(Password)").toBase64()
        }
    }
    
    /**
     Escape API Token using the base url, the authToken endpoint, and basic username and password
     */
    public func Login(completion: @escaping (Result<TokenData,Error>)->Void){
        guard let genURL = jamfURL.BuildJamfURL(baseURL: self.BaseURL, endpoint: UAPIEndpoints.authToken), let keepAliveURL = jamfURL.BuildJamfURL(baseURL: self.BaseURL, endpoint: UAPIEndpoints.authKeepAlive) else {
            os_log("login failed, url could not be read", log: .jamfAPI, type: .error)
            let error = NSError(domain: "LoginFailed", code: 0)
            completion(.failure(error))
            return
        }
        apiTokenManager.Initialize(basicCredentials: basicCreds, session: session, generateURL: genURL, keepAliveURL: keepAliveURL){
            (result) in
            switch result {
            case .success(let tokenData):
                os_log("login successful", log: .jamfAPI, type: .info)
                completion(.success(tokenData))
            case .failure(let error):
                os_log("login failed, an error occurred: %@", log: .jamfAPI, type: .error, error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    public func CheckStartupStatus(completion: @escaping ( Result<StartupStatus,Error>)->Void){
        guard let statusURL = jamfURL.BuildJamfURL(baseURL: self.BaseURL, endpoint: UAPIEndpoints.startupStatus) else {
            os_log("check status failed, url could not be read", log: .jamfAPI, type: .error)
            let error = NSError(domain: "StartupStatusCheckFailed", code: 0)
            completion(.failure(error))
            return
        }
        let request = URLRequest.init(url: statusURL , method: .get,accept: ContentType.json)
        _ = StartupStatus.StartupStatusRequest(request: request, session: session) { (result) in
            switch result{
                case .success(let startupStatus):
                    os_log("retrieved startupStatus", log: .jamfAPI, type: .info)
                    print(startupStatus)
                    completion(.success(startupStatus))
                case .failure(let error):
                    os_log("request failed, an error occurred: %@", log: .jamfAPI, type: .error, error.localizedDescription)
                    completion(.failure(error))
            }
            
        }
    }
    
    public func SetDBConnection(completion: @escaping (Result<Bool,Error>)->Void){
        guard let connectionURL = jamfURL.BuildJamfURL(baseURL: self.BaseURL, endpoint: UAPIEndpoints.initDBConnection) else {
            os_log("initialize database failed, url could not be read", log: .jamfAPI, type: .error)
            let error = NSError(domain: "initDBConnectionFailed", code: 0)
            completion(.failure(error))
            return
        }
        let encoder = JSONEncoder()
        guard let dataToSubmit = try? encoder.encode(InitDBConnection(password:"jamf1234")) else {
            let error = NSError(domain: "EncodePasswordFailed", code: 0)
            completion(.failure(error))
            return
        }
        let request = URLRequest.init(url: connectionURL, method: .post, dataToSubmit: dataToSubmit, contentType: ContentType.json)
        print(request)
        print(dataToSubmit)
        _ = session.dataTask(request: request){
            (result) in
            print(result)
        }
    }

}
