////
////  TestView.swift
////  testProj
////
////  Created by Andrew Pirkl on 12/1/19.
////  Copyright © 2019 PIrklator. All rights reserved.
////
//
//import SwiftUI
//
//
//
//struct TestView: View {
//
//    @ObservedObject var jamfAPIAccess: JamfAPIAccess
//
//    let idArray = ["23","18","19"]
//
//    var body: some View {
//        VStack {
//            Text("dostufwdfgsdfgf")
//            TextField("url", text: $jamfAPIAccess.BaseURL)
//            TextField("Username", text: $jamfAPIAccess.Username)
//            TextField("password", text: $jamfAPIAccess.Password)
////            Toggle(isOn: $jamfAPIAccess.viewDataRouter.AllowUntrusted) {
////                Text("Allow Untrusted")
////            }
//            Button(action: {
//                print("Logging In")
//                DispatchQueue.main.async{
////                    let _ = self.jamfAPIAccess.apiTokenManager.Initialize(basicCredentials: self.jamfAPIAccess.basicCreds, session: SessionHandler.SharedSessionHandler.mySession, generateURL: self.tokenURLData[0],keepAliveURL: self.tokenURLData[1])
//                }
//            }) {
//                Text("Log In")
//            }
//            Button(action: {
//                print("get computers")
//                DispatchQueue.main.async{
////                    let _ = self.jamfAPIAccess.GetComputerIDsFromSearchID(searchID: "17"){_ in
//
////                    }
//                }
//            }) {
//                Text("run serch")
//            }
//            Button(action: {
//                print("get a computer")
//                DispatchQueue.main.async{
//
////                    let _ = self.jamfAPIAccess.GetLogFromID(searchID: "23")
////                    let _ = self.jamfAPIAccess.ComputerHistoryArray(idArray: self.idArray){
////                        historyArray in
////                        print(historyArray)
////                    }
//                }
//            }) {
//                Text("get history")
//            }
//        }.frame(maxWidth: .infinity, maxHeight: .infinity)
//    }
//}
//
//struct TestView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestView(jamfAPIAccess: JamfAPIAccess())
//    }
//}
