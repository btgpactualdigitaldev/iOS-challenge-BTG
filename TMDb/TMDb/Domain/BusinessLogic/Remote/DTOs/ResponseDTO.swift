//
//  ResponseDTO.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation

struct ResponseDTO<T: DTO> {
    let code: Int?
    let status: String?
    let copyright: String?
    let attributionText: String?
    let attributionHTML: String?
    let etag: String?
    let data: T?
}

extension ResponseDTO: DTO {
    typealias M = Response<T.M>
    
    init(model: Response<T.M>?) {
        code            = model?.code
        status          = model?.status
        copyright       = nil
        attributionText = nil
        attributionHTML = nil
        etag            = model?.etag
        data            = T(model: model?.data)

    }
    
    func parseToModel() -> Response<T.M> {
        return .init(code: code.or(0),
                     status: status.or(""),
                     etag: etag.or(""),
                     data: data?.parseToModel())
    }
}
