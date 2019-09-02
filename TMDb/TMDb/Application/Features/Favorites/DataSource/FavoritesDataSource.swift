//
//  FavoritesDataSource.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

class FavoritesDataSource: NSObject {

    private var data: [Movie] = []
    private var filteredData: [Movie] = []
    private var isSearchLayout = false
    weak var delegate: CardInteractionDelegate?
    
    init(data: [Movie], handlerDelegate: CardInteractionDelegate?) {
        self.data = data
        self.delegate = handlerDelegate
    }

    func set(newData: [Movie]) {
        data = newData
    }

    func removeAllData() {
        data.removeAll()
        filteredData.removeAll()
    }

    func filterDataBy(_ query: String) {
        isSearchLayout = !query.isEmpty
        filteredData = data.filter({ (item) -> Bool in
            let itemName: NSString = NSString(string: item.title)
            return (itemName.range(of: query, options: .caseInsensitive).location) != NSNotFound
        })
    }
}

extension FavoritesDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getNumberOfItemsIn(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CardCollectionCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        switch getData() {
        case .filtred(let value):
            let item = value[indexPath.row]
            cell.configureWith(item: item) { [weak self] (item) in
                if !item.isFavorite {
                    if let index = self?.filteredData.index(of: item).map({ IndexPath(row: $0, section: 0) }) {
                        self?.delegate?.didRemoveFromFavorites(item, index: index)
                    }
                }
            }
            return cell
        case .full(let value):
            let item = value[indexPath.section][indexPath.row]
            cell.configureWith(item: item) { [weak self] (item) in
                if !item.isFavorite {
                    if let index = self?.data.index(of: item).map({ IndexPath(row: $0, section: 0) }) {
                        self?.delegate?.didRemoveFromFavorites(item, index: index)
                    }
                }
            }
        }
        return cell
    }
}

extension FavoritesDataSource: DataSourceProvider {
    func getNumberOfItemsIn(section: Int) -> Int {
        if isSearchLayout {
            return filteredData.count
        }
        return data.count
    }

    func getData() -> DataDiplayedType<Movie> {
        if isSearchLayout {
            return .filtred(filteredData)
        } else {
            return .full([data])
        }
    }

    func insert(_ item: Movie, at index: IndexPath) {
        if isSearchLayout {
            filteredData.insert(item, at: index.row)
        } else {
            data.insert(item, at: index.row)
        }
    }
}
