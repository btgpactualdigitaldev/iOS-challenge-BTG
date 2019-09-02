//
//  CardInteractionDelegate.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation

protocol CardInteractionDelegate: class {
    func didSelectItem(_ item: Movie)
    func didAddToFavorites(_ item: Movie)
    func didRemoveFromFavorites(_ item: Movie, index: IndexPath)
    func didAddToFavorites(_ items: [Movie])
}

extension CardInteractionDelegate {
    func didAddToFavorites(_ items: [Movie]) {}
    func didAddToFavorites(_ item: Movie) {}
}
