//
//  CSVBuilder.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/9/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import Foundation
class FileWriter {
    
    /**
     Write a string to a file
     
     - throws:
     An error of type NSError
     
     - parameters:
         - myString: The string to save
         - saveDirectory: Directory of the file to save
         - fileName: Name of the file to save
         - fileType: Extension of the file to save
     */
    func WriteString(myString: String, saveDirectory: URL, fileName: String, fileType: String) throws{
        let catURL = saveDirectory.appendingPathComponent(fileName+fileType)
        try myString.write(to: catURL, atomically: true, encoding: String.Encoding.utf8)
    }
    
    /**
     Write a string to a file with a date appended to the file name
     
     - throws:
     An error of type NSError
     
     - parameters:
         - myString: The string to save
         - saveDirectory: Directory of the file to save
         - fileName: Name of the file to save
         - fileType: Extension of the file to save
     */
    func WriteStringDated(myString: String, saveDirectory: URL, fileName: String,fileType: String) throws {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let date = formatter.string(from: Date())
        let catURL = saveDirectory.appendingPathComponent(fileName+"-"+date+fileType)
        try myString.write(to: catURL, atomically: true, encoding: String.Encoding.utf8)
    }
}
