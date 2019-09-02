//
//  Favorites.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

class Favorites: NSObject {

    var items: [Movie]?
    
    override init() {
        items = []
    }
    
    init(items: [Movie]?) {
        self.items = items
    }
}
