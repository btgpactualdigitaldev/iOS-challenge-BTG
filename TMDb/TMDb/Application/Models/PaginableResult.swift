//
//  PaginableResult.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation

class PaginableResult<T: Model>: Model {
    var offset: Int
    var limit: Int
    var total: Int
    var count: Int
    var results: [T]

    required init() {
        offset = 0
        limit = 0
        total = 0
        count = 0
        results = []
    }

    init(offset: Int, limit: Int, total: Int, count: Int, results: [T]) {
        self.offset = offset
        self.limit = limit
        self.total = total
        self.count = count
        self.results = results
    }
}
