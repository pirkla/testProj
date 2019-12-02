//
//  APITokenManager.swift
//  testProj
//
//  Created by Andrew Pirkl on 11/29/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import Foundation

// it's possible that if a token is renewed after a set of requests have been built that those requests will use the older invalid token. To avoid a race condition we would need a way to either reference the actual token that is getting changed when building the request, or check that it's valid.
// I don't think that could be built into a request though. Maybe we should just limit how many are queued up, then renew the token if it has less than a reasonable period of time to run. It's introducing a potential race condition which I don't like, but I'm not sure how to deal with it. For now the implementation is reasonable, but I'll think on it.
// I'm not sure if renewing a token will invalidate the older requests too. This requires some testing, but the rest of this class is solid.

// I think I should write a run call method that lets you inject authorization right before it runs. That seems like the only way to guarantee the issue doesn't present itself. Of course it's possible the renew token method runs at the same time and completes first, but who has time for that.

class APITokenManager: ObservableObject {
    
    private var session: URLSession?

    @Published public private(set) var tokenData: TokenData?
    private var urlData: TokenURLData?

    private var credentials: String?
    
//    init(basicCredentials:String,session: URLSession,urlData:TokenURLData){
//        self.credentials = basicCredentials
//        self.session = session
//        self.urlData = urlData
//        self.tokenData = TokenData(statusType:TokenStatusType.unknown)
//        let _ = generateToken(credentials:basicCredentials,url:urlData.generateURL,session:session)
//        {
//            (dataResult) in
//            self.tokenData = dataResult
//        }
//    }
    
    public func initialize(basicCredentials:String,session: URLSession,urlData:TokenURLData){
        self.credentials = basicCredentials
        self.session = session
        self.urlData = urlData
        self.tokenData = TokenData(statusType:TokenStatusType.unknown)
        let _ = generateToken(credentials:basicCredentials,url:urlData.generateURL,session:session)
        {
            (dataResult) in
            self.tokenData = dataResult
        }
    }
    
    private func generateToken(credentials:String,url: URL,session: URLSession, dataResult: @escaping (TokenData) -> Void) -> URLSessionDataTask
    {
        let myRequest = APIAccess.BuildRequest(url:url,basicCredentials:credentials,method:HTTPMethod.post,accept:ContentType.json)
        
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
    
//    private func keepAliveToken(session: URLSession,token:String,keepAliveURL:URL) -> TokenData
//    {
//
//    }
    private func invalidateToken(session: URLSession,token:String,invalidateURL:URL)
    {
        
    }
    private func validateToken(session: URLSession, token:String, validateURL:URL){
        
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
