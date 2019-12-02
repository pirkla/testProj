//
//  CredentialVerification.swift
//  testProj
//
//  Created by Andrew Pirkl on 11/27/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import Foundation

public class VerifyLogin{
    
    public static func VerifyCredentials(session: URLSession, url:String,username:String,password:String) -> Int
    {

        // lol wut? I can probably write this better but this is fine
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.get.rawValue
        let creds = String("\(username):\(password)").toBase64()
        request.addValue("Basic \(creds)", forHTTPHeaderField: "Authorization")
        
        var myResult: (Result<(URLResponse, Data), Error>)?
        let semaphore = DispatchSemaphore(value: 0)

        let myTask = APIAccess.RunCall(session: session,request: request) {
            (result) in
            myResult = result
            semaphore.signal()
        }
        myTask.resume()
        semaphore.wait()
        switch myResult {
        case .success(let response as HTTPURLResponse, _):
            if response.statusCode >= 200 && response.statusCode <= 299 {
                print("we got back success, so let's confirm creds work")
                return 0}
            else{
                print("response codes are out of range, so we probably have invalid credentials")
                return 1
            }
        case .failure( _):
            print("whuh oh! Looks like we can't reach the server at all")
            return 2
        default:
            return 2
        }
    }
}
