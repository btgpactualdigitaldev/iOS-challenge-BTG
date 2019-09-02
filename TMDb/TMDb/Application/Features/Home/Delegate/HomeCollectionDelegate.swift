//
//  CatalogDelegate.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

class HomeCollectionDelegate: NSObject {
    
    weak var delegate: CardInteractionDelegate?
    weak var paginationDelegate: PaginationDelegate?
    weak var dataProvider: DataSourceProvider?
    
    private var lastIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    private var numberOfColumns: Int = 2
    let cellPaddings: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)

    private var delayControlTime: TimeInterval = 0.5
    private var delayItem: DispatchWorkItem?
    
    init(dataProvider: DataSourceProvider?, handlerDelegate: CardInteractionDelegate?, paginationDelegate: PaginationDelegate?) {
        self.dataProvider = dataProvider
        self.delegate = handlerDelegate
        self.paginationDelegate = paginationDelegate
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension HomeCollectionDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if dataProvider?.getNumberOfItemsIn(section: section) == 0 {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 30)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if dataProvider?.dataIsLoading() == true {
            if section > 0 && collectionView.numberOfItems(inSection: 1) > 0 {
                return .init(width: collectionView.frame.width, height: 45)
            }
        }
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch dataProvider?.getData() {
        case .full? where indexPath.section == 0:
            let width: CGFloat = (collectionView.frame.width - (cellPaddings.left + cellPaddings.right))
            let height: CGFloat = width * 0.65
            return CGSize(width: width, height: height)
        default:
            let width: CGFloat = (collectionView.frame.width - (3 * cellPaddings.left)) / CGFloat(numberOfColumns)
            let height: CGFloat = width + (width * 0.50)
            return CGSize(width: width, height: height)
        }
    }
}

// MARK: UICollectionViewDelegate
extension HomeCollectionDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch dataProvider?.getData() {
        case .some(.filtred(let data)):
            let itemSelected = data[indexPath.row]
            delegate?.didSelectItem(itemSelected)
        case .some(.full(let data)):
            if indexPath.section > 0 {
                let itemSelected = data[indexPath.section][indexPath.row]
                delegate?.didSelectItem(itemSelected)
            }
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch dataProvider?.getData() {
        case .some(.full(let data)):
            if indexPath > lastIndexPath {
                if indexPath.row == data[1].count - 8 {
                    delayItem?.cancel()
                    delayItem = DispatchWorkItem { [weak self] in
                        self?.paginationDelegate?.paginate(to: data[1].count)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + delayControlTime,
                                                  execute: delayItem!)
                }
            }
            lastIndexPath = indexPath
        default:
            break
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionElementKindSectionFooter && indexPath.section > 0 {
            if self.dataProvider?.dataIsLoading() == true {
                view.startActivity()
            } else {
                view.stopActivity()
            }
        }
    }
}

// MARK: UICollectionViewDragDelegate
extension HomeCollectionDelegate: UICollectionViewDragDelegate {
    
    /*
     Method that drag single item
     */
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        switch dataProvider?.getData() {
        case .some(.filtred(let data)):
            let item = data[indexPath.row]
            if item.isFavorite { return [] }
            let itemProvider = NSItemProvider(object: item)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = item

            return [dragItem]
        case .some(.full(let data)):
            if indexPath.section != 0 {
                let item = data[indexPath.section][indexPath.row]
                if item.isFavorite { return [] }
                let itemProvider = NSItemProvider(object: item)
                let dragItem = UIDragItem(itemProvider: itemProvider)
                dragItem.localObject = item

                return [dragItem]
            } else {
                return []
            }
        default:
             return []
        }
    }
    
    /*
     Method that drag multiple items
     */
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        switch dataProvider?.getData() {
        case .some(.filtred(let data)):
            let item = data[indexPath.row]
            if item.isFavorite { return [] }
            let itemProvider = NSItemProvider(object: item)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = item

            return [dragItem]
        case .some(.full(let data)):
            if indexPath.section != 0 {
                let item = data[indexPath.section][indexPath.row]
                if item.isFavorite { return [] }
                let itemProvider = NSItemProvider(object: item)
                let dragItem = UIDragItem(itemProvider: itemProvider)
                dragItem.localObject = item

                return [dragItem]
            } else {
                return []
            }
        default:
            return []
        }
    }
}
