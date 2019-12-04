//
//  APITokenManager.swift
//  testProj
//
//  Created by Andrew Pirkl on 11/29/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import Foundation
import Combine


// the functions in this class mutate variables at the base class level, but some pretend like they don't
// this may be the best way to manage this, but the architecture should be rethought with that in mind since if we're not going to be functional we might as well go all in for object oriented
class APITokenManager: ObservableObject {
    
    
    @Published public private(set) var tokenData: TokenData = TokenData(statusType: TokenStatusType.waiting)

    private var session: URLSession?
    public private(set) var urlData: TokenURLData?
    private var credentials: String?
    private var timer: Timer?
    
    public func initialize(basicCredentials:String,session: URLSession,urlData:TokenURLData){
        self.credentials = basicCredentials
        self.session = session
        self.urlData = urlData
        self.tokenData = TokenData(statusType:TokenStatusType.waiting)
        
        let _ = retrieveToken(authType:AuthType.basic ,auth:basicCredentials,url:urlData.generateURL,session:session)
        {
            (dataResult) in
            DispatchQueue.main.async{
                self.tokenData = dataResult
                if dataResult.statusType == TokenStatusType.valid {
                    self.scheduleRenewal(tokenData: dataResult, keepAliveURL: urlData.keepAliveURL, session: session)
                }
            }
        }
    }
    
    public func EndToken(session:URLSession,invalidateURL:URL){
        guard let token = self.tokenData.token else{
            print("no token to invalidate")
            return
        }
        let _ = self.invalidateToken(session: session, token: token, invalidateURL: invalidateURL){
            (status) in
            DispatchQueue.main.async{
                if let myTimer = self.timer{
                    myTimer.invalidate()
                }
                self.tokenData.statusType = status
            }
        }
    }
    
    /**
     Post to an endpoint to get or renew an api token
     */
    private func retrieveToken(authType: AuthType, auth:String,url: URL,session: URLSession, dataResult: @escaping (TokenData) -> Void) -> URLSessionDataTask
    {
        var myRequest = APIAccess.BuildRequest(url:url,method:HTTPMethod.post,accept:ContentType.json)
        myRequest.addValue("\(authType.rawValue) \(auth)", forHTTPHeaderField: "Authorization")

        let myTask = APIAccess.RunCall(session:session, request:myRequest) {
            (result) in
            switch result {
            case .success(let response as HTTPURLResponse, let data):
                if response.statusCode >= 200 && response.statusCode <= 299 {
                    dataResult(self.parseAuthJSON(data: data))
                }
                else {
                    dataResult(TokenData(statusType:TokenStatusType.requestError))
                }
            case .failure(let error):
                print(error)
                dataResult(TokenData(statusType:TokenStatusType.sessionError))
            default:
                print("neither success or error reported")
                dataResult(TokenData(statusType:TokenStatusType.unknown))
            }
        }
        myTask.resume()
        return myTask
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
                let _ = self.retrieveToken(authType:AuthType.bearer ,auth:auth,url:keepAliveURL,session:session){
                    (dataResult) in
                    let myTokenData = dataResult
                    DispatchQueue.main.async{
                        self.tokenData = myTokenData
                        print("renewed token")
                        if myTokenData.statusType != TokenStatusType.valid{
                            print("token could not be renewed")
                            timer.invalidate()
                        }
                    }
                }
            }
            let runLoop = RunLoop.current
            runLoop.add(timer, forMode: RunLoop.Mode.default)
            runLoop.run()
            if let myTimer = self.timer{
                myTimer.invalidate()
            }
            self.timer = timer
        }
    }
    
    private func invalidateToken(session: URLSession,token:String,invalidateURL:URL, status:  @escaping (TokenStatusType) -> Void) -> URLSessionDataTask
    {
        let myRequest = APIAccess.BuildRequest(url:invalidateURL,token:token,method:HTTPMethod.post,accept:ContentType.json)
        
        let myTask = APIAccess.RunCall(session:session, request:myRequest) {
            (result) in
            switch result {
            case .success(let response as HTTPURLResponse, _):
                if response.statusCode >= 200 && response.statusCode <= 299 {
                    status(TokenStatusType.invalidated)
                    print("token invalidated")
                }
                else {
                    status(TokenStatusType.unknown)
                    print("invalidation failed")
                }
            case .failure(let error):
                print(error)
                status(TokenStatusType.unknown)
            default:
                print("neither success nor error reported")
                status(TokenStatusType.unknown)
            }
        }
        myTask.resume()
        return myTask
    }
    
    private func parseAuthJSON(data:Data) -> TokenData
    {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            if let dictionary = json as? [String: Any] {
                if let myToken = dictionary["token"] as? String {
                    if let myExpiration = dictionary["expires"] as? Double {
                        let date = Date(timeIntervalSince1970: myExpiration/1000)
                        return TokenData(token: myToken, expiration: date, statusType: TokenStatusType.valid)
                    }
                }
            }
    }
    catch let error as NSError
    {
        print(error)
        return TokenData(statusType: TokenStatusType.parseError)
        }
        return TokenData(statusType: TokenStatusType.parseError)
    }
}
