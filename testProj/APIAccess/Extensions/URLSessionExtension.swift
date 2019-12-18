//
//  URLSessionExtension.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/7/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import Foundation

extension URLSession {
    /**
     Run a dataTask escaping a result
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
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
            if statusCode >= 200 && statusCode <= 299 {
                result(.success(data))
                return
            }
            let error = NSError(domain: "httpError", code: statusCode, userInfo: nil)
            result(.failure(error))
        }
    }
    /**
     Run an array of dataTasks, escaping an array of results
     */
    func dataTaskArray(batchSize:Int=10,batchDelay:Double=0.5, tokenProvider:TokenProvider?=nil, requestArray: [URLRequest], resultArray: @escaping ([Result<Data, Error>]) -> Void) -> [URLSessionDataTask] {
        
        var myTaskArray = [URLSessionDataTask]()
        
        DispatchQueue.global().async{
            let startTime = Date()

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
            }
            let runTime = startTime.timeIntervalSince(Date())
            print(-runTime)
            resultArray(myResultArray)
            
        }
        return myTaskArray
    }
}
