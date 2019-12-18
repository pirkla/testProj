//
//  SearchResult.swift
//  testProj
//
//  Created by Andrew Pirkl on 12/7/19.
//  Copyright © 2019 PIrklator. All rights reserved.
//

import Foundation

struct SearchResult {
    var name: String
    var id: Int
}

extension SearchResult {
    init(json: [String: Any]) throws {
        guard let name = json["name"] as? String else {
            throw SerializationError.missing("name")
        }
        guard let id = json["id"] as? Int else {
            throw SerializationError.missing("id")
        }
        self.name = name
        self.id = id
    }
}

