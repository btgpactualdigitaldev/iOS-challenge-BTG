//
//  UpcomingMoviesWidgetDataSourceAndDelegate.swift
//  HeroesOfTheDay
//
//  Created by Renato De Souza Machado Filho on 06/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

protocol UpcomingMoviesWidgetInteractionDelegate: class {
    func didSelectItem(_ item: Movie)
}

class UpcomingMoviesWidgetDataSourceAndDelegate: NSObject {
    var data: [Movie] = []
    weak var delegate: UpcomingMoviesWidgetInteractionDelegate?

    func removeAllData() {
        data.removeAll()
    }

    func set(newData: [Movie]) {
        if newData.count == 0 {
            return
        }
        data = newData
    }
}

extension UpcomingMoviesWidgetDataSourceAndDelegate: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = data[indexPath.row]
        let cell: UpcomingWidgetCollectionCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.configureWith(item: item)
        return cell
    }
}

extension UpcomingMoviesWidgetDataSourceAndDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectItem(data[indexPath.row])
    }
}
