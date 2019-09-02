//
//  Genre.swift
//  TMDb
//
//  Created by Renato Machado Filho on 19/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation

class Genre: Model {
    var id: Int
    var name: String

    required init() {
        id = 0
        name = ""
    }

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
