//
//  DetailsInteractor.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

class DetailsInteractor: AbstractInteractor {

    private var data: Movie
    private var repository: MovieRepository
    
    init(data: Movie, repository: MovieRepository) {
        self.repository = repository
        self.data       = data
    }

    func getData() -> Movie {
        updateData()
        return data
    }

    private func updateData() {
        let item = MovieEntity.get(data)
        data.isFavorite = (item?.isFavorite).or(false)
    }

    func addToFavorites() {
        data.isFavorite = true
        repository.saveAsFavorites([data])
    }

    func removeFromFavorites() {
        data.isFavorite = false
        repository.deleFromFavorites([data])
    }
}
