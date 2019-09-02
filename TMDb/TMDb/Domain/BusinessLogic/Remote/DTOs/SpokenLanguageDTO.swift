//
//  SpokenLanguage.swift
//  TMDb
//
//  Created by Renato Machado Filho on 19/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation

struct SpokenLanguageDTO: Codable {
    let iso6391, name: String?

    enum CodingKeys: String, CodingKey {
        case iso6391 = "iso_639_1"
        case name
    }
}
