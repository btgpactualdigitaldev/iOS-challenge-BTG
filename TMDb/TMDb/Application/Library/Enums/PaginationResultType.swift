//
//  PaginationResultType.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation

enum PaginationResultType {
    case insertPageData(count: Int, update: (() -> Void))
    case newData
    case noData
}
