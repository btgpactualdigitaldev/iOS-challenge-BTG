//
//  HomeCollectionDataSource.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

class HomeCollectionDataSource: NSObject {

    weak var delegate: CardInteractionDelegate?
    private var data: [[Movie]] = [[],[]]
    private var filteredData: [Movie] = []
    var isSearchLayout = false {
        didSet {
            if oldValue == false {
                filteredData.removeAll()
            }
        }
    }
    private(set) var currentPage: Int {
        get { return data[1].count }
        set {}
    }
    
    init(newData: [Movie], delegate: CardInteractionDelegate?) {
        super.init()
        self.delegate = delegate

        if newData.count == 0 {
            currentPage = 0
            return
        }
        
        currentPage = newData.count
        
        var tempData = newData
        data[0] = tempData.count > 3 ? Array(tempData[..<3]) : tempData
        data[1] = tempData
    }
    
    func set(newData: [Movie]) {
        currentPage = newData.count

        if newData.count == 0 {
            return
        }
        
        var tempData: [Movie]
        if currentPage == 0 {
            tempData = newData
            data[0] = tempData.count > 3 ? Array(tempData[..<3]) : tempData
            data[1].removeAll()
        } else {
            tempData = data[1] + newData
        }
        data[1] = tempData
    }
    
    func removeAllData() {
        data[0].removeAll()
        data[1].removeAll()
    }
    
    func updateWith(favorites items: [Movie]) {
        switch getData() {
        case .filtred(let data):
            self.data[1] = data.compactMap { (favoriteItem) in
                favoriteItem.isFavorite = items.contains(favoriteItem)
                return favoriteItem
            }
        case .full(let data):
            self.data[1] = data[1].compactMap { (favoriteItem) in
                favoriteItem.isFavorite = items.contains(favoriteItem)
                return favoriteItem
            }
        }
    }

    func filterDataBy(_ query: String) {
        isSearchLayout = !query.isEmpty
        filteredData = data[1].filter({ (item) -> Bool in
            let itemName: NSString = NSString(string: item.title)
            return (itemName.range(of: query, options: .caseInsensitive).location) != NSNotFound
        })
    }
}

extension HomeCollectionDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if isSearchLayout {
            return 1
        } else {
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getNumberOfItemsIn(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let cell: SectionHeaderReusableView = collectionView.dequeueReusableSuplementaryView(kind: .header, indexPath: indexPath)
            if !isSearchLayout {
                if indexPath.section == 0 {
                    cell.titleLabel.text = "Upcoming"
                } else {
                    cell.titleLabel.text = "Movies"
                }
            } else {
                if indexPath.section == 0 {
                    cell.titleLabel.text = "Result"
                }
            }
            return cell
        } else {
            return collectionView.dequeueReusableSuplementaryView(kind: .footer, indexPath: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch getData() {
        case .filtred(let value):
            let cell: CardCollectionCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            let item = value[indexPath.row]
            cell.configureWith(item: item) { [weak self] (item) in
                guard let self = self else { return }
                if item.isFavorite {
                    self.delegate?.didAddToFavorites(item)
                } else {
                    if let index = value.index(of: item).map({ IndexPath(row: $0, section: 0) }) {
                        self.delegate?.didRemoveFromFavorites(item, index: index)
                    }
                }
            }
            return cell
        case .full(let value) where indexPath.section == 0:
            let cell: BannerCollectionCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.configureWith(items: value[indexPath.section])
            return cell
        case .full(let value):
            let cell: CardCollectionCell = collectionView.dequeueReusableCell(indexPath: indexPath)
            let item = value[indexPath.section][indexPath.row]
            cell.configureWith(item: item) { [weak self] (item) in
                guard let self = self else { return }
                if item.isFavorite {
                    self.delegate?.didAddToFavorites(item)
                } else {
                    if let index = value[indexPath.section].index(of: item).map({ IndexPath(row: $0, section: indexPath.section) }) {
                        self.delegate?.didRemoveFromFavorites(item, index: index)
                    }
                }
            }
            return cell
        }
    }
}

extension HomeCollectionDataSource: DataSourceProvider {
    func getNumberOfItemsIn(section: Int) -> Int {
        if isSearchLayout {
            return data[1].count
        } else {
            if section == 0 {
                return data[section].count > 0 ? 1 : 0
            } else {
                return data[section].count
            }
        }
    }

    func getData() -> DataDiplayedType<Movie> {
        if isSearchLayout {
            return .filtred(filteredData)
        } else {
            return .full(data)
        }
    }
}
