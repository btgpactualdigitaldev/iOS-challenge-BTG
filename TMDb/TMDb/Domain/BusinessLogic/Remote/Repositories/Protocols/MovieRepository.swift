//
//  MovieRepository.swift
//  TMDb
//
//  Created by Renato Machado Filho on 14/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation

protocol MovieRepository: Repository {
    func fetchUpcoming(page: Int, _ completion: @escaping ResultCompletion<PaginableResult<Movie>>)
    func fetchMovieDetails(id: Int, _ completion: @escaping ResultCompletion<Movie>)
    func fetchFavorites() -> [Movie]
    func saveAsFavorites(_ items: [Movie])
    func deleFromFavorites(_ items: [Movie])
}
