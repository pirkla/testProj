//
//  PrinterCollection.swift
//  testProj
//
//  Created by Andrew Pirkl on 1/6/20.
//  Copyright © 2020 PIrklator. All rights reserved.
//


// uri1 https://developer.apple.com/documentation/applicationservices/1460543-pmprintercopydeviceuri?language=objc
// uri2 https://developer.apple.com/documentation/applicationservices/core_printing/1805547-pmprintergetdeviceuri?language=objc
// ppd loc https://developer.apple.com/documentation/applicationservices/core_printing/1805546-pmprintergetdescriptionurl?language=objc
// ppd url https://developer.apple.com/documentation/applicationservices/1459187-pmprintercopydescriptionurl?language=objc
// hostname https://developer.apple.com/documentation/applicationservices/1462076-pmprintercopyhostname?language=objc
// location https://developer.apple.com/documentation/applicationservices/1461467-pmprintergetlocation?language=objc
// make and model name https://developer.apple.com/documentation/applicationservices/1463347-pmprintergetmakeandmodelname?language=objc
// name https://developer.apple.com/documentation/applicationservices/1459018-pmprintergetname?language=objc
import Foundation
import os.log

class PrinterCollection {
    
    public static func getAvailablePrinterList2() -> (err: OSStatus, printerNames: [String]?)
    {
        var outPrinters: CFArray? = nil
        var outPrinterNames: [String]? = nil
        
        // Obtain the list of PMPrinters
        var outPrintersUnmanaged: Unmanaged<CFArray>?
        let err: OSStatus = PMServerCreatePrinterList( nil, &outPrintersUnmanaged )
        outPrinters = outPrintersUnmanaged?.takeUnretainedValue()
        
        if let printerArray = outPrinters {
            var printerNames: [String] = []
            for idx in 0 ..< CFArrayGetCount(printerArray) {
                let printer = PMPrinter(CFArrayGetValueAtIndex(printerArray, idx))!
                let nameUnmanaged: Unmanaged<CFString>? = PMPrinterGetName(printer)
                guard let name = nameUnmanaged?.takeUnretainedValue() as String? else {
                    continue
                }
                printerNames.append(name)
            }
            outPrinterNames = printerNames
            print(outPrinterNames)
        }
        return (err, outPrinterNames)
    }

    public static func getAvailablePrinterList() -> (err: OSStatus, printerNames: [String]?)
    {
        var outPrinterNames: [String]? = nil
        
        // Obtain the list of PMPrinters
        var outPrinterPointers: Unmanaged<CFArray>?
        let err: OSStatus = PMServerCreatePrinterList( nil, &outPrinterPointers )
        var printerList = outPrinterPointers?.takeUnretainedValue()
        
        if let printerArray = printerList {
            var printerNames: [String] = []
            for idx in 0 ..< CFArrayGetCount(printerArray) {
                let printer = PMPrinter(CFArrayGetValueAtIndex(printerArray, idx))!
                let nameUnmanaged: Unmanaged<CFString>? = PMPrinterGetName(printer)
                guard let name = nameUnmanaged?.takeUnretainedValue() as String? else {
                    continue
                }
                printerNames.append(name)
            }
            outPrinterNames = printerNames
            print(outPrinterNames)
        }
        return (err, outPrinterNames)
    }


}
