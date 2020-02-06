//
//  APITokenManager.swift
//  testProj
//
//  Created by Andrew Pirkl on 11/29/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import Foundation
import os.log
// This could be cleaned up further by extending the TokenData struct
// needs more verbose error output as this is a major failure point
// this class shouldn't be relied on to provide interface data, but currently is implemented like it does
// this class sucks
// you dummy you made the renewal always use the first token - fixed - so dirty

class APITokenManager: TokenProvider {
    public private(set) var tokenData: TokenData = TokenData(statusType: TokenStatusType.waiting)

    // timer to schedule renewal of API token
    private var renewalTimer: Timer = Timer()
    

    /**
     Retrieve the api token, and schedule renewal
     */
    public func Initialize(basicCredentials:String,session: URLSession,generateURL: URL, keepAliveURL: URL, completion: @escaping (Result<TokenData, Error>) -> Void){
        os_log("initialized",log: .tokenManager, type: .debug)

        self.tokenData = TokenData(statusType:TokenStatusType.waiting)
        let myRequest = URLRequest(url: generateURL, basicCredentials: basicCredentials, method: HTTPMethod.post)
        let _ = TokenData.RetrieveToken(request: myRequest, session: session)
        {
            (result) in
            switch result {
            case .success(let tokenData):
                self.tokenData = tokenData
                if tokenData.statusType == TokenStatusType.valid {
                    os_log("api token created",log: .tokenManager, type: .info)
                    self.scheduleRenewal(keepAliveURL: keepAliveURL, session: session)
                    completion(.success(tokenData))
                }
                else {
                    os_log("api token could not be created",log: .tokenManager, type: .error)
                    let error = NSError(domain: "TokenRetrieval", code: 0)
                    completion(.failure(error))
                }
            case .failure(let error):
                os_log("api token could not be created: %@",log: .tokenManager, type: .error, error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    /**
     Invalidate the api token
     */
    public func EndToken(session:URLSession,invalidateURL:URL){
        os_log("invalidating token",log: .tokenManager, type: .info)
        guard let token = self.tokenData.token else {
            os_log("no token to invalidate",log: .tokenManager, type: .info)
            return
        }
        let myRequest = URLRequest(url:invalidateURL,token:token,method:HTTPMethod.post,accept:ContentType.json)

        let _ = TokenData.InvalidateToken(request: myRequest, session: session){
            isSuccess in
            self.renewalTimer.invalidate()
            if !isSuccess{
                os_log("Could not invalidate token",log: .tokenManager, type: .error)
                self.tokenData.statusType = TokenStatusType.unknown
                return
            }
            os_log("token invalidated",log: .tokenManager, type: .info)
            self.tokenData.statusType = TokenStatusType.invalidated
        }
    }
    
    /**
     Force renewal of the api token
     */
    public func ForceRenewToken(keepAliveURL:URL,session:URLSession){
        guard let auth = self.tokenData.token else {
            os_log("no token present, something went wrong",log: .tokenManager, type: .error)
            return
        }
        let myRequest = URLRequest(url: keepAliveURL, token: auth, method: HTTPMethod.post)
        let _ = TokenData.RetrieveToken(request: myRequest, session: session)
        {
            (result) in
            switch result {
            case .success(let tokenData):
                os_log("token renewed",log: .tokenManager, type: .info)
                self.tokenData = tokenData
            case .failure(let error):
                os_log("token could not be renewed: %@",log: .tokenManager, type: .error, error.localizedDescription)
            }
        }
    }
    
    // welcome to callback hell
    private func scheduleRenewal(keepAliveURL:URL,session:URLSession)
    {
        DispatchQueue.global(qos: .background).async{
            let expSpan = Date().timeIntervalSince(self.tokenData.expiration ?? Date().addingTimeInterval(-30 * 60))
            let interval = Double(-expSpan/2)
            let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true){
                timer in
                os_log("scheduled token renewal started",log: .tokenManager, type: .info)

                guard let auth = self.tokenData.token else {
                    os_log("no token present, something went wrong",log: .tokenManager, type: .error)
                    timer.invalidate()
                    return
                }
                
                let myRequest = URLRequest(url: keepAliveURL, token: auth, method: HTTPMethod.post)
                let _ = TokenData.RetrieveToken(request: myRequest, session: session){
                    (result) in
                    switch result {
                    case .success(let tokenData):
                        self.tokenData = tokenData
                        os_log("token renewed",log: .tokenManager, type: .info)
                        if tokenData.statusType != TokenStatusType.valid{
                            os_log("token could not be renewed, an unknown error occurred",log: .tokenManager, type: .error)
                            timer.invalidate()
                        }
                    case .failure(let error):
                        os_log("token could not be renewed: %@",log: .tokenManager, type: .error, error.localizedDescription)
                    }
                }
                
            }
            let runLoop = RunLoop.current
            runLoop.add(timer, forMode: RunLoop.Mode.default)
            runLoop.run()
            self.renewalTimer.invalidate()
            self.renewalTimer = timer
        }
    }
}
