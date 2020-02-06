//
//  PrinterCombine.swift
//  testProj
//
//  Created by Andrew Pirkl on 1/7/20.
//  Copyright © 2020 PIrklator. All rights reserved.
//

import Foundation
import os.log

class PrinterCombine{
    
    private var jamfURL = JamfURL()
    
    var baseURL: String
    var basicCreds: String
    var session: URLSession
    
    init(baseURL: String, basicCreds: String, session:URLSession){
        self.baseURL = baseURL
        self.basicCreds = basicCreds
        self.session = session
    }
    
    public func GetJamfPrinterArray(idArray: [String], historyArray: @escaping ([JamfPrinter]) -> Void) -> [URLSessionDataTask]{
        var requestArray: [URLRequest] = []
        for id in idArray {
            if let myURL = jamfURL.BuildJamfURL(baseURL: baseURL, endpoint: CAPIEndpoints.printers, identifierType: IdentifierType.id, identifier: id){
                let myRequest = URLRequest(url:myURL,basicCredentials:basicCreds, method: HTTPMethod.get, accept: ContentType.json)
                requestArray.append(myRequest)
            }
            else{
                os_log("an unknown error occurred, printer will not be collected",log: .jamfAPI, type: .error)
            }
        }
        let taskArray = JamfPrinter.PrinterRequestArray(requestArray:requestArray,session:session){myArray in
            historyArray(myArray)
        }
        return taskArray
    }
    
    public func RunPrinterSearch(searchResArray: @escaping ([SearchResult]?) -> Void) -> URLSessionDataTask?
    {
        guard let myURL = jamfURL.BuildJamfURL(baseURL:baseURL, endpoint: CAPIEndpoints.printers) else {
            os_log("No url was passed, something went wrong",log: .jamfAPI, type: .error)
            return nil
        }
        let myRequest = URLRequest(url: myURL,basicCredentials:basicCreds, method: HTTPMethod.get,accept: ContentType.json)
        
        let search = PrinterSearch.SearchRequest(request: myRequest, session: session){
            result in
            switch result{
            case .success(let search):
                print(search)
                searchResArray(search.printers)
            case .failure(let error):
                print(error)
            }
        }
        return search
    }
    
    public func GetAllPrinters(retHistoryArray: @escaping ([JamfPrinter]) -> Void) {
        DispatchQueue.global().async
            {
                let group = DispatchGroup()
                var searchIDs: [String] = []
                group.enter()
                _ = self.RunPrinterSearch(){
                    searchResults in
                    guard let searchResults = searchResults else {
                        os_log("No search result found, no history will be collected",log: .jamfAPI, type: .info)
                        retHistoryArray(Array())
                        return
                    }
                    for myResult in searchResults{
                        searchIDs.append(String(myResult.id))
                    }
                    group.leave()
                }
                group.wait()

                _ = self.GetJamfPrinterArray(idArray: searchIDs) {
                    printerArray in
                    DispatchQueue.main.async {
//                        self.computerHistoryArray = compHistoryArray
                        print(printerArray)
                        retHistoryArray(printerArray)
                    }

                }
        }
    }
}
