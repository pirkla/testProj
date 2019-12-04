//
//  ReportWindow.swift
//  testProj
//
//  Created by Andrew Pirkl on 11/27/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//
import SwiftUI

struct ReportView: View {
    @ObservedObject var viewDataRouter: ViewDataRouter
    @ObservedObject var apiTokenManager: APITokenManager

    var body: some View {
        VStack {
            Text("We're In!")
            Text(viewDataRouter.BaseURL)
            Text(viewDataRouter.Username)
            Text(viewDataRouter.Password)
            Button(action: {
                print("running action")
                DispatchQueue.main.async{
                    guard let invalidateURL = self.apiTokenManager.urlData?.invalidateURL else {
                        print("no invalidate url provided")
                        return
                    }
                    let _ = self.apiTokenManager.EndToken(session: SessionHandler.SharedSessionHandler.mySession, invalidateURL: invalidateURL)
                }
            }) {
                Text("Invalidate Token")
                
            }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        
        }
    }


struct ReportView_Preview: PreviewProvider {
    static var previews: some View {
        ReportView(viewDataRouter: ViewDataRouter(),apiTokenManager: APITokenManager())
    }
}
