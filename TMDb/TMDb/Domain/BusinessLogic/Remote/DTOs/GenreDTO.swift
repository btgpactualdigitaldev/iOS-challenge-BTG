//
//  GenreDTO.swift
//  TMDb
//
//  Created by Renato Machado Filho on 19/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation

struct GenreDTO {
    let id: Int?
    let name: String?
}

extension GenreDTO: DTO {
    typealias M = Genre

    init(model: Genre?) {
        id = model?.id
        name = model?.name
    }

    func parseToModel() -> Genre {
        return .init(id: id.or(0),
                     name: name.or(""))
    }
}
