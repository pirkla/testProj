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

    var body: some View {
        VStack {
            // should seperate this logic into its own function
            if viewDataRouter.loginStatus == LoginStatus.NotLoggedIn
            {
                LoginView(viewDataRouter: viewDataRouter)
            }
            else if viewDataRouter.loginStatus == LoginStatus.LoggedIn
            {
                ReportView(viewDataRouter: viewDataRouter)

            }
            else if viewDataRouter.loginStatus == LoginStatus.LoggingIn
            {
                WaitingView(viewDataRouter: viewDataRouter)
            }
            else {
                Text("We shouldn't be here")
                }
            TestView()
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView(viewDataRouter: ViewDataRouter())
    }
}
