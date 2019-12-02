//
//  APIAccess.swift
//  testProj
//
//  Created by Andrew Pirkl on 11/24/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import Foundation
/**
 Run operations against an API
 */
public class APIAccess {

    /**
     Build a basic request without authentication
     */
    public static func BuildRequest(url:URL, method: HTTPMethod,dataToSubmit:Data?=nil,contentType:ContentType?=nil,accept:ContentType?=nil) -> URLRequest
    {
        var myRequest = URLRequest(url: url)
        myRequest.httpMethod = method.rawValue
        if let contentType = contentType {
            myRequest.addValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        }
        if let accept = accept {
            myRequest.addValue(accept.rawValue, forHTTPHeaderField: "Accept")
        }
        if let dataToSubmit = dataToSubmit{
            myRequest.httpBody = dataToSubmit
        }
        return myRequest
    }
    /**
     Build a request using basic authentication
     */
    public static func BuildRequest(url:URL,basicCredentials:String,method: HTTPMethod,dataToSubmit:Data?=nil,contentType:ContentType?=nil,accept:ContentType?=nil) -> URLRequest
    {
        var myRequest = BuildRequest(url:url,method:method,dataToSubmit:dataToSubmit,contentType:contentType,accept:accept)
        myRequest.addValue("Basic \(basicCredentials)", forHTTPHeaderField: "Authorization")
        return myRequest
    }
    /**
     Build a request using a bearer token for authorization
     */
    public static func BuildRequest(url:URL,token:String,method: HTTPMethod,dataToSubmit:Data?=nil,contentType:ContentType?=nil,accept:ContentType?=nil) -> URLRequest
    {
        var myRequest = BuildRequest(url:url,method:method,dataToSubmit:dataToSubmit,contentType:contentType,accept:accept)
        myRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return myRequest
    }
    
    /**
     Run a single request escaping a result
     */
    public static func RunCall(session: URLSession, request : URLRequest,result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask
    {
        let myTask = session.dataTask(with: request)
        { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            result(.success((response, data)))
        }
        return myTask
    }
    
    /**
     Run an array of requests escaping an array of results
     */
    public static func RunRequestGroup(session: URLSession, myRequestArray : [URLRequest],resultArray: @escaping ([(Result<(URLResponse, Data), Error>)]) -> Void) -> [URLSessionDataTask]
    {
        var myTaskArray = [URLSessionDataTask]()
        DispatchQueue.global().async{
            var myResultArray = [(Result<(URLResponse, Data), Error>)]()
            let group = DispatchGroup()
            for myRequest in myRequestArray {
                group.enter()
                let myDataTask = APIAccess.RunCall(session: session, request: myRequest)
                {
                    (result) in
                    myResultArray.append(result)
                    group.leave()
                }
                myTaskArray.append(myDataTask)
                myDataTask.resume()
            }
            group.wait()
            resultArray(myResultArray)
        }
        return myTaskArray
    }

    /**
     A sample group request - poorly implemented and not for use
     */
    public func GroupSample()
    {
        let sessionHandler = SessionHandler.SharedSessionHandler

        let creds = String("user:pass").toBase64()
        var request = URLRequest(url: URL(string: "https://tryitout.jamfcloud.com/JSSResource/computers")!)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("Basic \(creds)", forHTTPHeaderField: "Authorization")
        sessionHandler.setAllowUntrusted(allowUntrusted: true)
        
        var myArray: [(URLResponse?, Data?)] = []
        let group = DispatchGroup()
        for n in 0...50 {
            group.enter()
            let myTask = APIAccess.RunCall(session: sessionHandler.mySession,request: request) {
                (result) in
                switch result {
                    case .success(let response, let data):
                        myArray.append((response, data))
                        print(n)
                        print("We got some data up in here")
                        let responseData = String(data: data, encoding: String.Encoding.utf8)
                        print((String(describing: responseData)))
                    case .failure(let error):
                        print("whuh oh!")
                        print(error)
                }
                group.leave()
            }
            myTask.resume()
        }
        group.wait()
    }
    
    /**
     A sample single request - poorly implemented and not for use
     */
    func SemaphoreSample()
    {
        let sessionHandler = SessionHandler.SharedSessionHandler

        let creds = String("user:pass").toBase64()
        var request = URLRequest(url: URL(string: "https://tryitout.jamfcloud.com/JSSResource/computers")!)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("Basic \(creds)", forHTTPHeaderField: "Authorization")
        sessionHandler.setAllowUntrusted(allowUntrusted: true)
                
        var myResult: (Result<(URLResponse, Data), Error>)?
        let semaphore = DispatchSemaphore(value: 0)

        let myTask = APIAccess.RunCall(session: sessionHandler.mySession,request: request) {
            (result) in
            myResult = result
            semaphore.signal()
        }
        myTask.resume()
        semaphore.wait()
        switch myResult {
        case .success(let response, let data):
            print("We got a response from something, let's assume it works for now")
            print(response)
            print(data)
            return
        case .failure(let error):
            print("whuh oh! Looks like we can't reach the server at all")
            print(error)
            return
        default:
            return
        }
    }
}
