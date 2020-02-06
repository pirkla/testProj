//
//  PrinterSearch.swift
//  testProj
//
//  Created by Andrew Pirkl on 1/7/20.
//  Copyright © 2020 PIrklator. All rights reserved.
//

import Foundation
import os.log
import CoreWLAN

struct PrinterSearch: Codable{
    var printers: [SearchResult]
}

extension PrinterSearch {

    static func SearchRequest(request: URLRequest, session: URLSession, completion: @escaping (Result<PrinterSearch,Error>) -> Void) -> URLSessionDataTask {
        let dataTask = session.dataTask(request: request){
            (result) in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let responseObject = try decoder.decode(PrinterSearch.self, from: data)
                    completion(.success(responseObject))
                }
                catch {
                    print(error)
                    completion(.failure(error))
                }
            case .failure(let error):
                os_log("Error returned: %@",log: .jamfAPI, type: .error,error.localizedDescription)
                completion(.failure(error))
            }
        }
        dataTask.resume()
        return dataTask
    }
}
