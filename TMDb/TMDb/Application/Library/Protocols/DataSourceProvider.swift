//
//  DataSourceProvider.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation

enum DataDiplayedType<T> {
    case filtred([T])
    case full([[T]])
}

protocol DataSourceProvider: class {
    func getNumberOfItemsIn(section: Int) -> Int
    func getData() -> DataDiplayedType<Movie>
    func dataIsLoading() -> Bool
    func insert(_ item: Movie, at index: IndexPath)
}

extension DataSourceProvider {
    func insert(_ item: Movie, at index: IndexPath) {}

    func dataIsLoading() -> Bool {
        return false
    }
}
