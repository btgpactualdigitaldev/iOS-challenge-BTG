//
//  PaginableResultDTO.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation

struct PaginableResultDTO<T: DTO> {
    let results: [T]?
    let page, totalResults: Int?
    let totalPages: Int?

    enum CodingKeys: String, CodingKey {
        case results, page
        case totalResults = "total_results"
        case totalPages = "total_pages"
    }
}

extension PaginableResultDTO: DTO {
    typealias M = PaginableResult<T.M>

    init(model: PaginableResult<T.M>?) {
        page           = model?.offset
        totalPages     = model?.total
        totalResults   = model?.count
        results        = model?.results.compactMap(T.init)
    }

    func parseToModel() -> PaginableResult<T.M> {
        return .init(offset: page.or(0),
                     limit: 0,
                     total: totalPages.or(0),
                     count: totalResults.or(0),
                     results: results.or([]).compactMap({ $0.parseToModel() }))
    }
}
