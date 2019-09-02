//
//  UpcomingMoviesWidgetViewController.swift
//
//
//  Created by Renato De Souza Machado Filho on 06/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit
import NotificationCenter
import Anchors

@objc(HeroesOfTheDayWidgetViewController)
class UpcomingMoviesWidgetViewController: ViewController, NCWidgetProviding {

    var collectionView: UICollectionView!
    var presenter: UpcomingMoviesWidgetPresenter!

    struct Layout {
        struct CollectionView {
            static let collectionSize: CGSize           = .init(width: 1, height: 165)
            static let backgroundColor: UIColor         = .clear
            static let itemSize: CGSize                 = CGSize(width: 105, height: 150)
            static let minimumLineSpacing: CGFloat      = 10
            static let minimumInteritemSpacing: CGFloat = 10
            static let sectionInset: UIEdgeInsets       = .init(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
            static let itemIdentifier                   = UpcomingWidgetCollectionCell.className
        }
    }

    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let collectionViewLayout                     = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize                = Layout.CollectionView.itemSize
        collectionViewLayout.minimumLineSpacing      = Layout.CollectionView.minimumLineSpacing
        collectionViewLayout.minimumInteritemSpacing = Layout.CollectionView.minimumInteritemSpacing
        collectionViewLayout.scrollDirection         = .vertical
        collectionViewLayout.sectionInset            = Layout.CollectionView.sectionInset
        return collectionViewLayout
    }()

    override func loadView() {
        view = .init(frame: .init(x: 0, y: 0, width: 600, height: 600))
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = .init(width: 600, height: 600)
    }
    
    override func prepareViews() {
        presenter      = .init(self)
        collectionView = .init(frame: .zero, collectionViewLayout: .init())
    }

    override func addViewHierarchy() {
        view.addSubview(collectionView)
        collectionView.register(UpcomingWidgetCollectionCell.self, forCellWithReuseIdentifier: Layout.CollectionView.itemIdentifier)
    }

    override func setupConstraints() {
        activate(
            collectionView.anchor.left.right.top.bottom.equal.to(view.anchor),
            collectionView.anchor.height.equal.to(Layout.CollectionView.collectionSize.height)
        )
    }

    override func configureViews() {
        view.backgroundColor           = .grayThemeColor
        let dataSourceAndDelegate      = presenter.getDataSourceAndDelegate(vc: self)
        collectionView.dataSource      = dataSourceAndDelegate
        collectionView.delegate        = dataSourceAndDelegate
        collectionView.backgroundColor = Layout.CollectionView.backgroundColor
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.collectionViewLayout = collectionViewFlowLayout
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        view.startActivity()
        presenter.fetchData { (result) in
            switch result {
            case .success(let value):
                switch value {
                case .newData:
                    completionHandler(.newData)
                    self.collectionView.reloadData()
                case .noData:
                    completionHandler(.noData)
                default:
                    completionHandler(.failed)
                }
            case .failure:
                completionHandler(.failed)
            }
            self.view.stopActivity()
        }
    }

    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let padding: UIEdgeInsets = .init(top: 5, left: 15, bottom: 5, right: 15)
        if activeDisplayMode == .compact {
            self.preferredContentSize = maxSize
            collectionViewFlowLayout.scrollDirection = .horizontal
            collectionView.contentInset              = .init(top: 0, left: 5, bottom: 0, right: 0)
            collectionViewFlowLayout.itemSize        = .init(width: (maxSize.width - padding.left - padding.right - (Layout.CollectionView.minimumLineSpacing * 2)) / 3,
                                                      height: maxSize.height - padding.top - padding.bottom)
            collectionViewFlowLayout.invalidateLayout()
        } else if activeDisplayMode == .expanded {
            self.preferredContentSize                = .init(width: maxSize.width, height: 330)
            collectionViewFlowLayout.scrollDirection = .vertical
            collectionView.contentInset              = .init(top: 5, left: 0, bottom: 0, right: 0)
            collectionViewFlowLayout.itemSize        = .init(width: maxSize.width - padding.left - padding.right,
                                                             height: (330 - padding.top - padding.bottom - (Layout.CollectionView.minimumLineSpacing * 2)) / 3)
        }
        collectionViewFlowLayout.invalidateLayout()
        collectionView.reloadData()
    }
}

extension UpcomingMoviesWidgetViewController: UpcomingMoviesWidgetInteractionDelegate {
    func didSelectItem(_ item: Movie) {
        presenter.didSelect(item, context: extensionContext)
    }
}
