//
//  PrinterView.swift
//  testProj
//
//  Created by Andrew Pirkl on 1/6/20.
//  Copyright © 2020 PIrklator. All rights reserved.
//

import SwiftUI

struct PrinterView: View {
    
    var printerCombine: PrinterCombine
    
    var printerCollection = PrinterCollection()
    var body: some View {
        VStack {
            
//            Button(action: {var stuff = PrinterCollection.getAvailablePrinterList()
//                print(stuff)
//            }) {
//                Text("print printers")
//            }

            Text("Hello, World!")
            Button(action: {
                self.printerCombine.GetAllPrinters(){_ in}
            }) {
                Text("do stuff")
            }
        }
    }
}

struct PrinterView_Previews: PreviewProvider {
    static var previews: some View {
        PrinterView(printerCombine: PrinterCombine(baseURL: "", basicCreds: "", session: SessionHandler.SharedSessionHandler.mySession))
    }
}

