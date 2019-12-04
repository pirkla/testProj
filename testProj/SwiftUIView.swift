//
//  SwiftUIView.swift
//  testProj
//
//  Created by Andrew Pirkl on 11/18/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    @ObservedObject var viewDataRouter: ViewDataRouter
    @ObservedObject var apiTokenManager: APITokenManager = APITokenManager()
    let creds = String("admin:pass").toBase64()
    let tokenURLData = TokenURLData(generateURL:URL(string:"https://apirkl.jamfcloud.com/uapi/auth/tokens")!,keepAliveURL:URL(string:"https://apirkl.jamfcloud.com/uapi/auth/keepAlive")!,invalidateURL:URL(string:"https://apirkl.jamfcloud.com/uapi/auth/invalidateToken")!,validateURL:URL(string:"https://apirkl.jamfcloud.com/uapi/auth")!)
    
    var body: some View {
        VStack {
            if apiTokenManager.tokenData.statusType == TokenStatusType.waiting{
                LoginView(viewDataRouter:viewDataRouter, apiTokenManager: apiTokenManager)
            }
            else if apiTokenManager.tokenData.statusType == TokenStatusType.valid{
                ReportView(viewDataRouter:viewDataRouter, apiTokenManager: apiTokenManager)
            }
            else if apiTokenManager.tokenData.statusType == TokenStatusType.invalidated{
                LoginView(viewDataRouter:viewDataRouter, apiTokenManager: apiTokenManager)
            }            else {
                WaitingView(viewDataRouter:viewDataRouter, apiTokenManager: apiTokenManager)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView(viewDataRouter: ViewDataRouter())
    }
}
