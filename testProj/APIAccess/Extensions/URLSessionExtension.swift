//
//  URLSessionExtension.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/7/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import Foundation
import os.log

extension URLSession {
    
    struct DataTaskError: LocalizedError{
        enum ErrorKind {
            case emptyData
            case requestFailure
            case unknown
        }
        let errorDescription: String?
        let kind: ErrorKind
        let statusCode: Int
    }
    
    
    /**
     Run a dataTask escaping a result optionally adding a token provider for just in time authentication
     */
    func dataTask(tokenProvider:TokenProvider?=nil, request: URLRequest, result: @escaping (Result<Data, Error>) -> Void) -> URLSessionDataTask {
        var myRequest = request
        if let token = tokenProvider?.tokenData.token {
            myRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return dataTask(with: request) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = DataTaskError(errorDescription: "No response or data, something went wrong", kind: DataTaskError.ErrorKind.emptyData, statusCode: -1)
                result(.failure(error))
                return
            }
            guard let urlResponse = response as? HTTPURLResponse else {
                let error = DataTaskError(errorDescription: "an unknown error ocurred", kind: DataTaskError.ErrorKind.requestFailure,statusCode: -1)
                result(.failure(error))
                return
            }
            let statusCode = urlResponse.statusCode
            if statusCode < 200 || statusCode > 299 {
                let localizedString = "\(String(statusCode)): \(HTTPURLResponse.localizedString(forStatusCode: statusCode))"
                let error = DataTaskError(errorDescription: localizedString, kind: DataTaskError.ErrorKind.requestFailure,statusCode: statusCode)
                result(.failure(error))
                return
            }
            result(.success(data))
        }
    }
    /**
     Run an array of dataTasks, escaping an array of results optionally adding a token provider for just in time authentication
     */
    func dataTaskArray(batchSize:Int=10,batchDelay:Double=0.05, tokenProvider:TokenProvider?=nil, requestArray: [URLRequest], resultArray: @escaping ([Result<Data, Error>]) -> Void) -> [URLSessionDataTask] {
        
        var myTaskArray = [URLSessionDataTask]()
        
        DispatchQueue.global().async{
            let startTime = Date()
            os_log("Starting data task array",log: .network, type: .info)


            var myResultArray = [(Result<(Data), Error>)]()

            let batchedRequests = requestArray.batched(batchSize: batchSize)
            for batch in batchedRequests
            {
                let group = DispatchGroup()
                for request in batch {
                    group.enter()
                    let myDataTask = self.dataTask(tokenProvider:tokenProvider, request: request)
                    {
                        (result) in
                        myResultArray.append(result)
                        group.leave()
                    }
                    myTaskArray.append(myDataTask)
                    myDataTask.resume()
                }
                usleep(UInt32(batchDelay * 1000000))
                group.wait()
                os_log("batch completed",log: .network, type: .debug)

            }
            let runTime = startTime.timeIntervalSince(Date())
            os_log("data task array completed in: %@ seconds",log: .network, type: .info,String(-runTime))

            resultArray(myResultArray)
            
        }
        return myTaskArray
    }
}
