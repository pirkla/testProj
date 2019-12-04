//
//  LoginWindow.swift
//  testProj
//
//  Created by Andrew Pirkl on 11/27/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//
import SwiftUI

struct LoginView: View {
    @ObservedObject var viewDataRouter: ViewDataRouter
    @ObservedObject var apiTokenManager: APITokenManager
    let tokenURLData = TokenURLData(generateURL:URL(string:"https://apirkl.jamfcloud.com/uapi/auth/tokens")!,keepAliveURL:URL(string:"https://apirkl.jamfcloud.com/uapi/auth/keepAlive")!,invalidateURL:URL(string:"https://apirkl.jamfcloud.com/uapi/auth/invalidateToken")!,validateURL:URL(string:"https://apirkl.jamfcloud.com/uapi/auth")!)

    var body: some View {
        VStack {
            Text("Login Time!")
            TextField("url", text: $viewDataRouter.BaseURL)
            TextField("Username", text: $viewDataRouter.Username)
            TextField("password", text: $viewDataRouter.Password)
            Toggle(isOn: $viewDataRouter.AllowUntrusted) {
                Text("Allow Untrusted")
            }
            Button(action: {
                print("Logging In")
                let creds = String("\(self.viewDataRouter.Username):\(self.viewDataRouter.Password)").toBase64()
                DispatchQueue.main.async{
                    let _ = self.apiTokenManager.initialize(basicCredentials: creds, session: SessionHandler.SharedSessionHandler.mySession, urlData: self.tokenURLData)
                }
            }) {
                Text("Log In")
            }
            Text("Error Suggestion Placeholder")
            
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct LoginView_Preview: PreviewProvider {
    static var previews: some View {
        LoginView(viewDataRouter: ViewDataRouter(),apiTokenManager: APITokenManager())
    }
}
