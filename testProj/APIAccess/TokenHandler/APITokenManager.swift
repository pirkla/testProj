//
//  APITokenManager.swift
//  testProj
//
//  Created by Andrew Pirkl on 11/29/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import Foundation
import Combine

// This could be cleaned up further by extending the TokenData struct
// renewal/invalidation not fully implemented
// needs more verbose error output as this is a major failure point
// this class shouldn't be relied on to provide interface data, but currently is implemented like it does

class APITokenManager: ObservableObject, TokenProvider {
    public private(set) var tokenData: TokenData = TokenData(statusType: TokenStatusType.waiting)

    // timer to schedule renewal of API token
    private var renewalTimer: Timer = Timer()
    

    /**
     Retrieve the api token, and schedule renewal
     */
    public func Initialize(basicCredentials:String,session: URLSession,generateURL: URL, keepAliveURL: URL, completion: @escaping (Result<TokenData, Error>) -> Void){
        self.tokenData = TokenData(statusType:TokenStatusType.waiting)
        let myRequest = URLRequest(url: generateURL, basicCredentials: basicCredentials, method: HTTPMethod.post)
        let _ = TokenData.RetrieveToken(request: myRequest, session: session)
        {
            (result) in
            switch result {
            case .success(let tokenData):
                self.tokenData = tokenData
                if tokenData.statusType == TokenStatusType.valid {
                    self.scheduleRenewal(tokenData: tokenData, keepAliveURL: keepAliveURL, session: session)
                    completion(.success(tokenData))
                }
                else {
                    let error = NSError(domain: "TokenRetrieval", code: 100)
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /**
     Invalidate the api token
     */
    public func EndToken(session:URLSession,invalidateURL:URL){
        guard let token = self.tokenData.token else {
            print("no token to invalidate")
            return
        }
        let myRequest = URLRequest(url:invalidateURL,token:token,method:HTTPMethod.post,accept:ContentType.json)

        let _ = TokenData.InvalidateToken(request: myRequest, session: session){
            isSuccess in
            self.renewalTimer.invalidate()
            if !isSuccess{
                print("Could not invalidate token")
                self.tokenData.statusType = TokenStatusType.unknown
                return
            }
            DispatchQueue.main.async{
                self.tokenData.statusType = TokenStatusType.invalidated
            }
        }
    }
    
    /**
     Force renewal of the api token
     */
    public func ForceRenewToken(keepAliveURL:URL,session:URLSession){
        guard let auth = self.tokenData.token else {
            print("no authorization, something went wrong")
            return
        }
        let myRequest = URLRequest(url: keepAliveURL, token: auth, method: HTTPMethod.post)
        let _ = TokenData.RetrieveToken(request: myRequest, session: session)
        {
            (result) in
            switch result {
            case .success(let tokenData):
                self.tokenData = tokenData
                print("token renewed")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // welcome to callback hell
    private func scheduleRenewal(tokenData: TokenData,keepAliveURL:URL,session:URLSession)
    {
        DispatchQueue.global(qos: .background).async{
            let expSpan = Date().timeIntervalSince(tokenData.expiration ?? Date().addingTimeInterval(-30 * 60))
            let interval = Double(-expSpan/2)
            let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true){
                timer in
                print("renewing")
                
                guard let auth = tokenData.token else {
                    print("no authorization, something went wrong")
                    timer.invalidate()
                    return
                }
                
                let myRequest = URLRequest(url: keepAliveURL, token: auth, method: HTTPMethod.post)
                let _ = TokenData.RetrieveToken(request: myRequest, session: session){
                    (result) in
                    switch result {
                    case .success(let tokenData):
                        self.tokenData = tokenData
                        print("renewed token")
                        if tokenData.statusType != TokenStatusType.valid{
                            print("token could not be renewed")
                            timer.invalidate()
                        }
                    case .failure(let error):
                        print(error)
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
