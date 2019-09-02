//
//  Response.swift
//  ThoughtWorks-iOS
//
//  Created by Renato Machado Filho on 15/01/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation

class Response<T: Model>: Model {
    var code: Int
    var status: String
    var etag: String
    var data: T?

    required init () {
        code   = 0
        status = ""
        etag   = ""
    }

    init(code: Int, status: String, etag: String, data: T?) {
        self.code = code
        self.status = status
        self.etag = etag
        self.data = data
    }
}
