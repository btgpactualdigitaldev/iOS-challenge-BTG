//
//  MovieRemoteRepository.swift
//  TMDb
//
//  Created by Renato Machado Filho on 14/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation

struct MovieRemoteRepository: MovieRepository {
    private var network: NetworkManager<MovieService> = .init()

    func cancelRequest() {
        network.router.cancel()
    }

    func fetchUpcoming(page number: Int, _ completion: @escaping ResultCompletion<PaginableResult<Movie>>) {
        let service: MovieService = .getUpcoming(page: number)
        network.request(service: service) { (response: Result<PaginableResultDTO<MovieDTO>>) in
            switch response {
            case .success(let object):
                let value: PaginableResult<Movie> = object.parseToModel()
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchMovieDetails(id: Int, _ completion: @escaping ResultCompletion<Movie>) {
        let service: MovieService = .getMovieDetails(id: id)
        network.request(service: service) { (response: Result<MovieDTO>) in
            switch response {
            case .success(let object):
                let value: Movie = object.parseToModel()
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchFavorites() -> [Movie] {
        return FavoritesEntity.getModel().items.or([])
    }

    func saveAsFavorites(_ items: [Movie]) {
        let favoriteList = FavoritesEntity.getModel()
        var savedItems   = favoriteList.items?.filter({ !items.contains($0) }) ?? []
        savedItems      += items
        favoriteList.items = Array(Set(savedItems))
        FavoritesEntity.save(model: favoriteList)
    }
    
    func deleFromFavorites(_ items: [Movie]) {
        if items.count == 1 {
            FavoritesEntity.delete(items[0])
            return
        } else {
            let favoriteList = FavoritesEntity.getModel()
            let cleanFavoriteList = favoriteList.items?.filter({ !items.contains($0) }) ?? []
            favoriteList.items = cleanFavoriteList

            if favoriteList.items?.count == 0 {
                FavoritesEntity.delete()
            } else {
                FavoritesEntity.save(model: favoriteList)
            }
        }
    }
}
