//
//  CharacterFactory.swift
//  TMDbTests
//
//  Created by Renato De Souza Machado Filho on 08/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation
@testable import TMDb

struct MoviesFactory {
    var decoder: JSONDecoder
    
    init() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        decoder = .init()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    func generateListOfCharacteres(size: Int) -> PaginableResult<Movie> {
        guard let mockDTO: PaginableResultDTO<MovieDTO> = .fromJSON("TMDb", fileExtension: "json", decoder: decoder) else {
            fatalError()
        }
        let mockModel = mockDTO.parseToModel()
        mockModel.results = Array(mockModel.results.prefix(size))
        return mockModel
    }
}
