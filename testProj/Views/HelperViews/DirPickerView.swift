//
//  FilePickerView.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/9/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import SwiftUI

struct DirPickerView<T>: View where T: DirPickerData {
    @ObservedObject var dirPickerData: T

    var body: some View {
        VStack {
            if dirPickerData.WorkingDir != nil {
                Text("Working Directory: \(dirPickerData.WorkingDir!.path)")
            } else {
                Text("No selection")
            }
            Button(action: {
                let panel = NSOpenPanel()
                panel.canChooseFiles = false
                panel.canChooseDirectories = true
                panel.resolvesAliases = true
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    let result = panel.runModal()
                    if result == .OK {
                        self.dirPickerData.WorkingDir = panel.url
                    }
                }
            }) {
                Text("Select file")
            }
        }
        .frame(width: 640, height: 120)    }
}

//struct DirPickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        DirPickerView(dirPickerData: DirPickerData())
//    }
//}
