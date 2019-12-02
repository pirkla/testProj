//
//  TestView.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/1/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import SwiftUI



struct TestView: View {
    @ObservedObject var apiTokenManager: APITokenManager = APITokenManager()

    
    let creds = String("user:pass").toBase64()
    let tokenURLData = TokenURLData(generateURL:URL(string:"https://tryitout.jamfcloud.com/uapi/auth/tokens")!,keepAliveURL:URL(string:"https://tryitout.jamfcloud.com/uapi/auth/keepalive")!,invalidateURL:URL(string:"https://tryitout.jamfcloud.com/uapi/auth/invalidate")!,validateURL:URL(string:"https://tryitout.jamfcloud.com/uapi/auth")!)

    
    var body: some View {
        VStack {
            Text("dostuff")
            Text(String(apiTokenManager.tokenData?.token ?? "No Token Data"))
            Button(action: {
                print("running action")
                DispatchQueue.global().async{
                    let _ = self.apiTokenManager.initialize(basicCredentials: self.creds, session: SessionHandler.SharedSessionHandler.mySession, urlData: self.tokenURLData)
                }
            }) {
                Text(/*@START_MENU_TOKEN@*/"Button"/*@END_MENU_TOKEN@*/)
            }
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
