//
//  FavoritesDelegate.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

class FavoritesDelegate: NSObject {

    weak var dataProvider: DataSourceProvider!
    weak var delegate: CardInteractionDelegate?

    private let numberOfColumns: CGFloat = 2.0
    private let cellPaddings: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    
    init(dataProvider: DataSourceProvider, handlerDelegate: CardInteractionDelegate?) {
        self.dataProvider = dataProvider
        self.delegate = handlerDelegate
    }
}

// MARK: UICollectionViewDelegate
extension FavoritesDelegate: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var itemSelected: Movie
        switch dataProvider.getData() {
        case .filtred(let value):
            itemSelected = value[indexPath.row]
        case .full(let value):
            itemSelected = value[indexPath.section][indexPath.row]
        }
        delegate?.didSelectItem(itemSelected)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension FavoritesDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = (collectionView.frame.width - (3 * cellPaddings.left)) / numberOfColumns
        let height: CGFloat = width + (width * 0.50)
        return CGSize(width: width, height: height)
    }
}

// MARK: UICollectionViewDragDelegate
extension FavoritesDelegate: UICollectionViewDragDelegate {
    
    /*
     Method that drag single item
     */
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        switch dataProvider.getData() {
        case .filtred:
            return []
        case .full(let value):
            let item = value[indexPath.section][indexPath.row]
            let itemProvider = NSItemProvider(object: item)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = item
            return [dragItem]
        }
    }
    
    /*
     Method that drag multiple items
     */
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        
        switch dataProvider.getData() {
        case .filtred:
            return []
        case .full(let value):
            let item = value[indexPath.section][indexPath.row]
            let itemProvider = NSItemProvider(object: item)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = item
            return [dragItem]
        }
    }
}

// MARK: UICollectionViewDropDelegate
extension FavoritesDelegate: UICollectionViewDropDelegate {
    
    /*
     Method that define operations behavior.
     */
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        var destinationIndexPath: IndexPath
        
        if let idx = coordinator.destinationIndexPath {
            destinationIndexPath = idx
        } else {
            let section: Int = collectionView.numberOfSections - 1
            let row: Int = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        
        switch coordinator.proposal.operation {
        case .copy:
            
            collectionView.performBatchUpdates({
                
                var indexs: [IndexPath] = []
                var newFavoriteItems: [Movie] = []
                
                for (idx, obj) in coordinator.items.enumerated() {
                    let newIndex: IndexPath = IndexPath(item: destinationIndexPath.row + idx, section: destinationIndexPath.section)
                    
                    let item = obj.dragItem.localObject as! Movie
                    item.isFavorite = true
                    
                    newFavoriteItems.append(item)
                    dataProvider.insert(item, at: newIndex)
                    indexs.append(newIndex)
                }
                collectionView.insertItems(at: indexs)
                delegate?.didAddToFavorites(newFavoriteItems)
            }, completion: nil)
            
            break
        default:
            break
        }
    }
    
    /*
     Method that define operation type for each session
     */
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        let operation: UIDropOperation
        switch dataProvider.getData() {
        case .full:
            if session.localDragSession != nil {
                if collectionView.hasActiveDrag {
                    operation = .move
                } else {
                    operation = .copy
                }
            } else {
                operation = .cancel
            }
        default:
            operation = .cancel
        }
        return UICollectionViewDropProposal(operation: operation)
    }
}
