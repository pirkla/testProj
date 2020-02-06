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
    @ObservedObject var windowStateData: WindowStateData
    
    var body: some View {

        VStack {
            containedView()
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func containedView() -> AnyView {
        switch windowStateData.windowState{
        case .HistoryView:
            return AnyView(PickerView(windowStateData: windowStateData, jamfAPIAccess: jamfAPIAccess))
        case .Login:
            return AnyView(LoginView(jamfAPIAccess: jamfAPIAccess,windowStateDate: windowStateData))
//            return AnyView(PrinterView())
        case .Loading:
            return AnyView(LoginView(jamfAPIAccess: jamfAPIAccess,windowStateDate: windowStateData))
        case .Picker:
            return AnyView(PickerView(windowStateData: windowStateData, jamfAPIAccess: jamfAPIAccess))
        }
    }
}
struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView(jamfAPIAccess: JamfAPIAccess(),windowStateData: WindowStateData())
    }
}
