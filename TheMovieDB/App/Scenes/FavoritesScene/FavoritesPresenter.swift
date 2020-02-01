//
//  FavoritesPresenter.swift
//  TheMovieDB
//
//  Created by Usuario on 28/01/20.
//  Copyright (c) 2020 Usuario. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol FavoritesPresentationLogic
{
  func presentMovies(response: FavoritesScene.GetMovies.Response)
  func presentSelectedMovie(response: FavoritesScene.SelectMovie.Response)
}

class FavoritesPresenter: FavoritesPresentationLogic
{
  weak var viewController: FavoritesDisplayLogic?
  
  // MARK: Do something
    
  func presentMovies(response: FavoritesScene.GetMovies.Response) {
    let viewModel = FavoritesScene.GetMovies.ViewModel(movies: response.movies)
    viewController?.displayMovies(viewModel: viewModel)
  }
    
  func presentSelectedMovie(response: FavoritesScene.SelectMovie.Response) {
    let viewModel = FavoritesScene.SelectMovie.ViewModel()
    viewController?.displaySelectedMovie(viewModel: viewModel)
  }
}
