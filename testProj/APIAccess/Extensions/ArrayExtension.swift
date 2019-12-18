//
//  ArrayExtension.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/5/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

/**
 return elements of an array as an array of arrays of size batchSize
 */
extension Array {
    func batched(batchSize: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: batchSize).map {
            Array(self[$0 ..< Swift.min($0 + batchSize, count)])
        }
    }
}
