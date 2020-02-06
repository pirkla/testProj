//
//  WindowStateData.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/16/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import Foundation
import Combine
class WindowStateData: ObservableObject {

    let objectWillChange = PassthroughSubject<WindowStateData,Never>()
    @Published var windowState: WindowState = WindowState.Login {
        willSet(newValue) {
            DispatchQueue.main.async {
                self.objectWillChange.send(self)
            }
        }
    }
    @Published var errorMessage: String = "" {
        willSet(newValue) { objectWillChange.send(self)
        }
    }
    @Published var sharedMessage: String = "" {
        willSet(newValue) { objectWillChange.send(self)
        }
    }
    
    enum WindowState{
        case Login
        case Picker
        case HistoryView
        case Loading
    }
}
