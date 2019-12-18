//
//  CSVBuilder.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/9/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import Foundation
class FileWriter {
    
    func WriteString(myString: String, saveDirectory: URL, fileName: String, fileType: String){
        let catURL = saveDirectory.appendingPathComponent(fileName+fileType)
        _ = try? myString.write(to: catURL, atomically: true, encoding: String.Encoding.utf8)
    }
    func WriteStringDated(myString: String, saveDirectory: URL, fileName: String,fileType: String){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let date = formatter.string(from: Date())
        let catURL = saveDirectory.appendingPathComponent(fileName+"-"+date+fileType)
        print(catURL)
        _ = try? myString.write(to: catURL, atomically: true, encoding: String.Encoding.utf8)
    }
}
