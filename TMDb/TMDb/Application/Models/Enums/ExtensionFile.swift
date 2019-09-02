//
//  ExtensionFile.swift
//  Farfetch
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation

enum ExtensionFile: String, Codable {
    case jpg    = "jpg"
    case none   = ""

    init(rawValue: String) {
        switch rawValue {
        case "jpg":
            self = .jpg
        default:
            self = .none
        }
    }
}
