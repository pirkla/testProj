//
//  Login.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/8/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @ObservedObject var jamfAPIAccess: JamfAPIAccess
//    @ObservedObject var apiTokenManager: APITokenManager
    @ObservedObject var windowStateDate: WindowStateData
        
//    @State var allowUntrusted: Bool = false{
//        didSet(newValue) { SessionHandler.SharedSessionHandler.setAllowUntrusted(allowUntrusted: newValue)
//            print("trust set")
//        }
//    }
    
    var body: some View {
        VStack {
            Text("MRT")
            TextField("url", text: $jamfAPIAccess.BaseURL)
            TextField("Username", text: $jamfAPIAccess.Username)
            TextField("password", text: $jamfAPIAccess.Password)
            Toggle(isOn: $jamfAPIAccess.allowUntrusted) {
                Text("Allow Untrusted")
            }
            Button(action: {
                self.jamfAPIAccess.Login(){
                    result in
                    switch result{
                    case .success(_):
                        print("logging in")
                        self.windowStateDate.windowState = WindowStateData.WindowState.HistoryView
                    case .failure(let error):
                        print(error)
                    }
                }
            }) {
                Text("Log In")
            }
            Text("Error placeholder")

            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(jamfAPIAccess: JamfAPIAccess(),windowStateDate: WindowStateData())
    }
}
