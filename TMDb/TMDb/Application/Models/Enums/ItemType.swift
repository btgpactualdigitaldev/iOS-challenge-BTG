//
//  ItemType.swift
//  Farfetch
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation

enum ItemType: String, Codable {
    case cover          = "cover"
    case interiorStory  = "interiorStory"
    case none           = ""

    init(rawValue: String) {
        switch rawValue {
        case "cover":
            self = .cover
        case "interiorStory":
            self = .interiorStory
        default:
            self = .none
        }
    }
}
