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
    
    var body: some View {
        VStack {
            Text("Login Time!")
            TextField("url", text: $viewDataRouter.BaseURL)
            TextField("Username", text: $viewDataRouter.Username)
            TextField("password", text: $viewDataRouter.Password)
            //this needs to be fixed up
            Button(action: {
                self.viewDataRouter.loginStatus = LoginStatus.LoggingIn
                print(self.viewDataRouter.loginStatus)
                // brief delay so we actaully see the loading screen and know something happened
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let verification = VerifyLogin.VerifyCredentials(session: SessionHandler.SharedSessionHandler.mySession,url: self.viewDataRouter.BaseURL,username: self.viewDataRouter.Username,password:self.viewDataRouter.Password)
                    if verification == 0 {
                        self.viewDataRouter.loginStatus = LoginStatus.LoggedIn
                    }
                    else if verification == 1{
                        self.viewDataRouter.loginStatus = LoginStatus.NotLoggedIn
                    }
                    else{
                        self.viewDataRouter.loginStatus = LoginStatus.NotLoggedIn
                    }
                    
                }

            })
            {
                Text("login")
            }
            Toggle(isOn: $viewDataRouter.AllowUntrusted) {
                Text("Allow Untrusted")
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct LoginView_Preview: PreviewProvider {
    static var previews: some View {
        LoginView(viewDataRouter: ViewDataRouter())
    }
}
