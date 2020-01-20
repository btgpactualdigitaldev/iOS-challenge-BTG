//
//  ListMoviesViewModel.swift
//  iOS-challenge-BTG
//
//  Created by Bruno on 20/01/20.
//  Copyright © 2020 Bruno. All rights reserved.
//

import UIKit

class ListMoviesViewModel {

    let viewTitle = "Filmes populares"
    let movieService = MovieService()
    var movieViewModel = MovieViewModel()

}

// MARK: - Requests
extension ListMoviesViewModel {

    func fetchPopularMovies(completion: @escaping (MovieViewModel) -> ()) {
        self.movieService.fetchPopularMovies(with: self.movieViewModel.page) {
            (viewModel, serviceError) in

            if serviceError != nil {
                // TODO: Tratar erro
                return
            }

            if let viewModel = viewModel {
                self.movieViewModel.page = viewModel.page
                self.movieViewModel.totalPages = viewModel.totalPages
                self.movieViewModel.movies.append(contentsOf: viewModel.movies)

                completion(self.movieViewModel)
            }
        }
    }
}
