//
//  APIDelegate.swift
//  testProj
//
//  Created by Andrew Pirkl on 11/24/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//
import Foundation

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
        print("trust set")
    }
    // note: it works to allow untrusted because the info.plist has App Transport Security Settings > Allow Arbitrary Loads - Exception Usage > set to true
    // this is potentially unsafe if handled incorrectly, but if the user does not know how to trust the certificate this becomes difficult to implement if arbitrary loads aren't allowed
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping(  URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else{
            print("no server trust found")
            completionHandler(.performDefaultHandling,nil)
            return
        }
        if allowUntrusted {
            print("ignoring authentication***********")
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
        } else {
            print("requiring authentication*********")
            completionHandler(.performDefaultHandling, URLCredential(trust: serverTrust))
        }
    }
}
