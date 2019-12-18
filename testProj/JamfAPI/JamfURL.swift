//
//  URLExtensions.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/9/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import Foundation
class JamfURL {
    public func BuildJamfURL(baseURL: String, endpoint: String, identifierType: String?=nil, identifier: String? = nil) -> URL?
    {
        var myURL = baseURL.replacingOccurrences(of: "https:", with: "").replacingOccurrences(of: "http:", with: "").replacingOccurrences(of: "/", with: "")
        var port: Int?
        if let range = myURL.range(of: ":") {
            let portString = String(myURL[range.upperBound...])
            myURL.removeSubrange(range.lowerBound..<myURL.endIndex)
            port = Int(portString)
        }
        var components = URLComponents()
        components.scheme = "https"
        components.host = myURL
        components.port = port
        components.path = endpoint


        if let identifierType = identifierType, let identifier = identifier {
            components.path.append(contentsOf: identifierType)
            components.path.append(contentsOf: identifier)
        }
        return components.url
    }
    
    public func BuildJamfURLArray(baseURL: String, endpoint: String, identifierType: String, identifierArray: [String]) -> [URL?]
    {
        var myBaseURL = baseURL.replacingOccurrences(of: "https:", with: "").replacingOccurrences(of: "http:", with: "").replacingOccurrences(of: "/", with: "")
        var port: Int?
        if let range = myBaseURL.range(of: ":") {
            let portString = String(myBaseURL[range.upperBound...])
            myBaseURL.removeSubrange(range.lowerBound..<myBaseURL.endIndex)
            port = Int(portString)
        }
        
        var urlArray: [URL?] = []

        for identifier in identifierArray {
            var components = URLComponents()
            components.scheme = "https"
            components.host = myBaseURL
            components.port = port
            components.path = endpoint
            components.path.append(contentsOf: identifierType)
            components.path.append(contentsOf: identifier)
            urlArray.append(components.url)
        }
        return urlArray
    }

}
