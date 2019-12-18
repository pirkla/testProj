//
//  URLRequestExtension.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/8/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import Foundation

/**
 Build a request without authentication
 */
extension URLRequest{
    init(url:URL, method: HTTPMethod,dataToSubmit:Data?=nil,contentType:ContentType?=nil,accept:ContentType?=nil)
    {
        self.init(url:url)
        self.httpMethod = method.rawValue
        if let contentType = contentType {
            self.addValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        }
        if let accept = accept {
            self.addValue(accept.rawValue, forHTTPHeaderField: "Accept")
        }
        if let dataToSubmit = dataToSubmit{
            self.httpBody = dataToSubmit
        }
    }
    
    
    /**
     Build a request using basic authentication
     */
    init(url:URL,basicCredentials:String,method: HTTPMethod,dataToSubmit:Data?=nil,contentType:ContentType?=nil,accept:ContentType?=nil)
    {
        self.init(url:url,method:method,dataToSubmit:dataToSubmit,contentType:contentType,accept:accept)
        self.addValue("Basic \(basicCredentials)", forHTTPHeaderField: "Authorization")
    }
    /**
     Build a request using a bearer token for authorization
     */
    init(url:URL,token:String,method: HTTPMethod,dataToSubmit:Data?=nil,contentType:ContentType?=nil,accept:ContentType?=nil)
    {
        self.init(url:url,method:method,dataToSubmit:dataToSubmit,contentType:contentType,accept:accept)
        self.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
}
