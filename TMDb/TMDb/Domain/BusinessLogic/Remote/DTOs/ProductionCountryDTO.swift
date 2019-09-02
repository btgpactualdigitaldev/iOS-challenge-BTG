//
//  ProductionCountryDTO.swift
//  TMDb
//
//  Created by Renato Machado Filho on 19/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation

struct ProductionCountryDTO: Codable {
    let iso31661, name: String?

    enum CodingKeys: String, CodingKey {
        case iso31661 = "iso_3166_1"
        case name
    }
}
