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

    var body: some View {
        VStack {
            Text("We're In!")
            Text(viewDataRouter.BaseURL)
            Text(viewDataRouter.Username)
            Text(viewDataRouter.Password)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        
        }
    }


struct ReportView_Preview: PreviewProvider {
    static var previews: some View {
        ReportView(viewDataRouter: ViewDataRouter())
    }
}
