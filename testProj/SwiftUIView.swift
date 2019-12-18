//
//  SwiftUIView.swift
//  testProj
//
//  Created by Andrew Pirkl on 11/18/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var jamfAPIAccess: JamfAPIAccess
//    @ObservedObject var apiTokenManager: APITokenManager
    @ObservedObject var windowStateData: WindowStateData
    
    var body: some View {

        VStack {
            containedView()
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func containedView() -> AnyView {
        switch windowStateData.windowState{
        case .HistoryView:
            return AnyView(HistoryReportView(computerHistoryCombine: ComputerHistoryCombine(baseURL: jamfAPIAccess.BaseURL, basicCreds: jamfAPIAccess.basicCreds, session:SessionHandler.SharedSessionHandler.mySession), windowStateData: windowStateData))
        case .Login:
            return AnyView(LoginView(jamfAPIAccess: jamfAPIAccess,windowStateDate: windowStateData))
        case .Loading:
            return AnyView(LoginView(jamfAPIAccess: jamfAPIAccess,windowStateDate: windowStateData))
        }
    }
}
struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView(jamfAPIAccess: JamfAPIAccess(),windowStateData: WindowStateData())
    }
}
