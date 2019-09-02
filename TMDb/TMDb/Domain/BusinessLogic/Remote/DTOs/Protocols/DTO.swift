//
//  DTO.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation

protocol DTO: Codable {
    associatedtype M: Model
    init(model: M?)
    func parseToModel() -> M
}
