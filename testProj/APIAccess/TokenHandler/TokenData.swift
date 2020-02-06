//
//  APITokenData.swift
//  testProj
//
//  Created by Andrew Pirkl on 11/29/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import Foundation
import os.log

public struct TokenData{
    var token: String?
    var expiration: Date?
    var statusType: TokenStatusType
}

struct APITokenError: Error{
    enum ErrorKind {
        case parsing
        case emptyData
    }

    let line: Int
    let kind: ErrorKind
}

extension TokenData {
    init(json: [String: Any]) throws {
        self.statusType = TokenStatusType.unknown
        guard let token = json["token"] as? String else {
            os_log("TokenData serialization failed. Missing 'token'",log: .serialization, type: .error)
            throw SerializationError.missing("token")
        }
        guard let myExpiration = json["expires"] as? Double else{
            os_log("TokenData serialization failed. Missing 'expires'",log: .serialization, type: .error)
            throw SerializationError.missing("expires")
        }
        let date = Date(timeIntervalSince1970: myExpiration/1000)
        self.token = token
        self.expiration = date
        self.statusType = TokenStatusType.valid
    }
    
    
    static func RetrieveToken(request: URLRequest, session: URLSession, completion: @escaping (Result<TokenData, Error>) -> Void) -> URLSessionDataTask {
        let dataTask = session.dataTask(request: request){
            (result) in
            switch result {
            case .success(let data):
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = json as? [String: Any] {
                    let parsed = try? TokenData(json: dictionary)
                    if let parsed = parsed {
                        completion(.success(parsed))
                    }
                    else {
                        os_log("apiToken serialization failed",log: .serialization, type: .error)
                        let error = APITokenError(line:55,kind:APITokenError.ErrorKind.emptyData)
                        completion(.failure(error))
                    }
                }
                else {
                    os_log("apiToken serialization failed",log: .serialization, type: .error)
                    let error = APITokenError(line:59,kind:APITokenError.ErrorKind.parsing)
                    completion(.failure(error))
                }
            case .failure(let error):
                os_log("apiToken retrieval failed: %@",log: .network, type: .error,error.localizedDescription)
                completion(.failure(error))
            }
        }
        dataTask.resume()
        return dataTask
    }
    
    static func InvalidateToken(request: URLRequest, session: URLSession, isSuccess: @escaping (Bool) -> Void) -> URLSessionDataTask? {
        let dataTask = session.dataTask(request: request){
            (result) in
            switch result {
            case .success(_):
                isSuccess(true)
            case .failure(let error):
                os_log("apiToken invalidation failed: %@",log: .network, type: .error,error.localizedDescription)
                isSuccess(false)
            }
        }
        dataTask.resume()
        return dataTask
    }
}


