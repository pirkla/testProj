//
//  AdvancedComputerSearch.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/6/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import Foundation
import os.log


struct AdvancedComputerSearch {
    var id: Int
    var name: String
    var results: [SearchResult]

}

extension AdvancedComputerSearch {
    init(json: [String: Any]) throws {
        guard let searchDict = json["advanced_computer_search"] as? [String:Any] else {
            throw SerializationError.missing("advanced_computer_search")
        }
        guard let id = searchDict["id"] as? Int else {
            throw SerializationError.missing("name")
        }
        guard let name = searchDict["name"] as? String else {
            throw SerializationError.missing("name")
        }
        guard let myResultArray = searchDict["computers"] as? [[String:Any]] else {
            throw SerializationError.missing("computers")
        }
        var results: [SearchResult]=[]
    
        for myResult in myResultArray {
            if let searchResult = try? SearchResult(json:myResult){
                results.append(searchResult)
            }
        }
        self.id = id
        self.name = name
        self.results = results
    }

    static func SearchRequest(request: URLRequest, session: URLSession, completion: @escaping (AdvancedComputerSearch?) -> Void) -> URLSessionDataTask {
        let dataTask = session.dataTask(request: request){
            (result) in
            switch result {
            case .success(let data):
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = json as? [String: Any] {
                    let parsed = try? AdvancedComputerSearch.init(json: dictionary)
                    if let parsed = parsed {
                        completion(parsed)
                        os_log("Search result found",log: .jamfAPI, type: .info)
                    }
                    else {
                        completion(nil)
                        os_log("No search result found",log: .jamfAPI, type: .info)
                    }
                }
                else {
                    completion(nil)
                    os_log("No search result found",log: .jamfAPI, type: .info)
                }
            case .failure(let error):
                guard let myError = error as? URLSession.DataTaskError else {
                    os_log("Error returned: %@",log: .jamfAPI, type: .error,error.localizedDescription)
                    completion(nil)
                    return
                }
                if myError.statusCode == 404{
                    os_log("No result found",log: .jamfAPI, type: .info)
                    completion(nil)
                    return
                }
                os_log("Error returned: %@",log: .jamfAPI, type: .error,error.localizedDescription)
                completion(nil)
            }
        }
        dataTask.resume()
        return dataTask
    }
}
