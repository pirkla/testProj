//
//  ViewRouter.swift
//  testProj
//
//  Created by Andrew Pirkl on 11/27/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//
import Combine
import SwiftUI

class ViewDataRouter: ObservableObject, UserData {
    let objectWillChange = PassthroughSubject<ViewDataRouter,Never>()
    
//    var loginStatus: LoginStatus = LoginStatus.NotLoggedIn {
//        didSet {
//            objectWillChange.send(self)
//        }
//    }
    @Published var BaseURL: String = "https://url" {
        willSet(newValue) { objectWillChange.send(self)
        }
    }
    @Published var Username: String = "username"{
        willSet(newValue) { objectWillChange.send(self)
        }
    }
    @Published var Password: String = "password"{
        willSet(newValue) { objectWillChange.send(self)
        }
    }
    var AllowUntrusted: Bool = false
}
