//
//  Login.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/8/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import SwiftUI
import os.log
struct LoginView: View {
    
    @ObservedObject var jamfAPIAccess: JamfAPIAccess
    @ObservedObject var windowStateDate: WindowStateData
    @State var errorMessage: String = ""

    @State var animate = true
    
    var body: some View {
        VStack {
            Text("dINg DoNg")
            TextField("URL", text: $jamfAPIAccess.BaseURL).frame(width: 300, alignment: .center)
            TextField("Username", text: $jamfAPIAccess.Username).frame(width: 300, alignment: .center)
            SecureField("password", text: $jamfAPIAccess.Password).frame(width: 300, alignment: .center)
            Toggle(isOn: $jamfAPIAccess.allowUntrusted) {
                Text("Allow Untrusted")
            }
            Button(action: {
                self.errorMessage = "loading"
//                self.jamfAPIAccess.CheckStartupStatus(){
//                    _ in
//                }
//                self.jamfAPIAccess.SetDBConnection(){
//                    _ in
//                }
                self.jamfAPIAccess.Login(){
                    result in
                    switch result{
                    case .success(_):
                        os_log("Login Finished", log: .ui, type: .info)

                        self.windowStateDate.windowState = WindowStateData.WindowState.Picker
                    case .failure(let error):
                        os_log("Login failed: %@", log: .ui, type: .error,error.localizedDescription)
                        self.errorMessage = error.localizedDescription
                    }
                }
            }) {
                Text("Log In")
            }
            Text(errorMessage)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(jamfAPIAccess: JamfAPIAccess(),windowStateDate: WindowStateData())
    }
}
