//
//  APIDelegate.swift
//  testProj
//
//  Created by Andrew Pirkl on 11/24/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//
import Foundation
import os.log

/**
    URLSessionDelegate  to ignore or force authentication to the server.
 */
public class APIDelegate: NSObject, URLSessionDelegate
{
    private var allowUntrusted: Bool = false
    /**
     Set SSL Certificate trust settings
     */
    func setTrust(allowUntrusted: Bool)
    {
        self.allowUntrusted = allowUntrusted
        os_log("allow untrusted switched to: %@", log: .network, type: .debug, allowUntrusted ? "true" : "false")
    }
    
    // note: it works to allow untrusted because the info.plist has App Transport Security Settings > Allow Arbitrary Loads - Exception Usage > set to true
    // this is potentially unsafe if handled incorrectly, but if the user does not know how to trust the certificate this becomes difficult to implement if arbitrary trust isn't allowed
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping(  URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else{
            completionHandler(.performDefaultHandling,nil)
            return
        }
        if allowUntrusted {
            os_log("Ignoring SSL Authentication. CAUTION: This is potentially unsafe", log: .network, type: .info)
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else {
            os_log("Requiring SSL Authentication",log: .network, type: .debug)
            completionHandler(.performDefaultHandling, URLCredential(trust: serverTrust))
        }
    }
}
