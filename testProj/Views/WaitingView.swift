//
//  WaitingView.swift
//  testProj
//
//  Created by Andrew Pirkl on 11/27/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//
import SwiftUI

struct WaitingView: View {
    @ObservedObject var viewDataRouter: ViewDataRouter
    @ObservedObject var apiTokenManager: APITokenManager

    var body: some View {
        VStack {
            Text("Hold up for a second")
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

struct WaitingView_Preview: PreviewProvider {
    static var previews: some View {
        WaitingView(viewDataRouter: ViewDataRouter(), apiTokenManager: APITokenManager())
    }
}
