//
//  JamfAPIAccess.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/6/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import Foundation
import Combine

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
    
    @Published var allowUntrusted: Bool = false{
        willSet(newValue) {objectWillChange.send(self)
            SessionHandler.SharedSessionHandler.setAllowUntrusted(allowUntrusted: newValue)
            print("changed trust")
        }
    }
//    @Published var WorkingDir: URL?{
//            didSet(newValue) { objectWillChange.send(self)
//        }
//    }
    
        
    public private(set) var apiTokenManager: APITokenManager = APITokenManager()
    private var session = SessionHandler.SharedSessionHandler.mySession
    private var jamfURL = JamfURL()
    
    public var basicCreds : String {
        get {
            return String("\(Username):\(Password)").toBase64()
        }
    }
    
    public func Login(completion: @escaping (Result<TokenData,Error>)->Void){
        print(apiTokenManager.tokenData.statusType)
        guard let genURL = jamfURL.BuildJamfURL(baseURL: self.BaseURL, endpoint: UAPIEndpoints.authToken), let keepAliveURL = jamfURL.BuildJamfURL(baseURL: self.BaseURL, endpoint: UAPIEndpoints.authKeepAlive) else {
            print("login failed")
            let error = NSError(domain: "LoginFailed", code: 100)
            completion(.failure(error))
            return
        }
        apiTokenManager.Initialize(basicCredentials: basicCreds, session: session, generateURL: genURL, keepAliveURL: keepAliveURL){
            (result) in
            switch result {
            case .success(let tokenData):
                completion(.success(tokenData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
