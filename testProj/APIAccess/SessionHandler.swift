//
//  SessionHandler.swift
//  testProj
//
//  Created by Andrew Pirkl on 11/24/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//
import Foundation
import os.log
/**
 Configurable Global URLSession Instance
 */
public class SessionHandler
{
    /**
     Access singleton session handler
     */
    public static let SharedSessionHandler = SessionHandler()
    /**
     Access singleton URLSession
     */
    public let mySession: URLSession

    private let myDelQueue = OperationQueue()
    private let myDelegate = APIDelegate()
    private init()
    {
        os_log("URLSession initialized",log: .network, type: .debug)
        let config = URLSessionConfiguration.default
        // currently hardcoded to only allow 1 connection at a time to throttle the request speed.
        config.httpMaximumConnectionsPerHost = 1
        self.mySession = URLSession(configuration: .default, delegate: myDelegate, delegateQueue: myDelQueue)
    }
    /**
     Set trust for URLSession singleton. Note this will switch trust for queued tasks.
     */
    public func setAllowUntrusted(allowUntrusted : Bool){
        myDelegate.setTrust(allowUntrusted: allowUntrusted)
    }
}
