//
//  TestView.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/1/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import SwiftUI



struct TestView: View {
    @ObservedObject var viewDataRouter: ViewDataRouter
    @ObservedObject var apiTokenManager: APITokenManager
    let creds = String("admin:pass").toBase64()
    let tokenURLData = TokenURLData(generateURL:URL(string:"https://apirkl.jamfcloud.com/uapi/auth/tokens")!,keepAliveURL:URL(string:"https://apirkl.jamfcloud.com/uapi/auth/keepAlive")!,invalidateURL:URL(string:"https://apirkl.jamfcloud.com/uapi/auth/invalidateToken")!,validateURL:URL(string:"https://apirkl.jamfcloud.com/uapi/auth")!)

    
    var body: some View {
        VStack {
            Text("dostuff")
            Text(String(apiTokenManager.tokenData.token ?? "No Token Data"))
            Text(String(apiTokenManager.tokenData.expiration?.toString(dateFormat:"yyyy-MM-dd HH:mm:ss") ?? "No expire Data"))

            Button(action: {
                print("running action")
                DispatchQueue.main.async{
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
        TestView(viewDataRouter: ViewDataRouter(), apiTokenManager: APITokenManager())
    }
}
