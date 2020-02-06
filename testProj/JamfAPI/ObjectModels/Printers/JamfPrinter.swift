//
//  printerModel.swift
//  testProj
//
//  Created by Andrew Pirkl on 1/7/20.
//  Copyright © 2020 PIrklator. All rights reserved.
//

import Foundation
import os.log

struct JamfPrinterParent: Codable {
    var printer: JamfPrinter
}
struct JamfPrinter {
    var id: Int?
    var name: String?
    var category: String?
    var uri: String?
    var CUPSName: String?
    var location: String?
    var model: String?
    var shared: Bool?
    var info: String?
    var notes: String?
    var makeDefault: Bool?
    var useGeneric: Bool?
    var ppd: String?
    var ppdPath: String?
    var ppdContents: String?
    var osRequirements: String?
}

extension JamfPrinter : Codable{
    
    func toJSON() -> Data? {
        let encoder = JSONEncoder()
        guard let dataToSubmit = try? encoder.encode(self) else {
            os_log("failed to encode printer data", log: .serialization, type: .error)
            return nil
        }
        return dataToSubmit
    }
    
    static func PrinterRequest(request: URLRequest, session: URLSession, completion: @escaping (Result<JamfPrinter,Error>)-> Void) -> URLSessionDataTask {
        let dataTask = session.dataTask(request: request) {
            (result) in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let responseObject = try decoder.decode(JamfPrinterParent.self, from: data)
                    completion(.success(responseObject.printer))
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
    
    static func PrinterRequestArray(requestArray: [URLRequest], session: URLSession, completion: @escaping ([JamfPrinter]) -> Void) -> [URLSessionDataTask] {
        var printerArray: [JamfPrinter] = []
        let dataTaskArray = session.dataTaskArray(requestArray:requestArray){resultArray in
            for result in resultArray{
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let responseObject = try decoder.decode(JamfPrinterParent.self, from: data)
                        printerArray.append(responseObject.printer)
                    }
                    catch {
                        os_log("Error returned: %@",log: .jamfAPI, type: .error,error.localizedDescription)
                    }
                case .failure(let error):
                    os_log("Error returned: %@",log: .jamfAPI, type: .error,error.localizedDescription)
                }
            }
            completion(printerArray)
        }
        return dataTaskArray
    }
}
