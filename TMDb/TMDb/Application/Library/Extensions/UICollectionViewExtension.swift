//
//  UICollectionViewExtension.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    fileprivate struct AssociatedObjectKeys {
        static var refreshContolHandler: UInt8 = 0
    }
    
    fileprivate typealias Action = (_ refreshControl: UIRefreshControl)-> Swift.Void?
    
    fileprivate var refreshControlAction: Action? {
        get { return objc_getAssociatedObject(self, &AssociatedObjectKeys.refreshContolHandler) as? Action }
        set { objc_setAssociatedObject(self, &AssociatedObjectKeys.refreshContolHandler, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    @objc fileprivate func handleRefreshControlAction(sender : UIRefreshControl) {
        refreshControlAction?(sender)
    }

    func refreshControlHandler(block: @escaping (_ refreshControl: UIRefreshControl)-> Void) {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(UICollectionView.handleRefreshControlAction(sender:)), for: UIControlEvents.valueChanged)
        
        if #available(iOS 10.0, *) {
            self.refreshControl = refreshControl
        } else {
            self.addSubview(refreshControl)
        }
        refreshControlAction = block
    }
}

extension UICollectionView {
    enum ReusableCollectionView {
        case header
        case footer
        var value: String {
            switch self {
            case .header:
                return UICollectionElementKindSectionHeader
            case .footer:
                return UICollectionElementKindSectionFooter
            }
        }
    }

    func dequeueReusableCell<T: UICollectionViewCell>(indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withReuseIdentifier: T.className, for: indexPath) as? T
        return cell.or(.init())
    }

    func dequeueReusableSuplementaryView<T: UICollectionReusableView>(kind: ReusableCollectionView, indexPath: IndexPath) -> T {
        let reusableView = dequeueReusableSupplementaryView(ofKind: kind.value, withReuseIdentifier: T.className, for: indexPath) as? T
        return reusableView.or(.init())
    }
}
