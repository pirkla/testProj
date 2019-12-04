//
//  DateExtension.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/2/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import Foundation

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}
