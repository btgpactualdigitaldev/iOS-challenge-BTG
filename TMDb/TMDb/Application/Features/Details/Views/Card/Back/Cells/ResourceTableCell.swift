//
//  ResourceTableCell.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit
import Anchors

protocol ResourceItemInteractionDelegate: class {
    func didSelect(item: Genre)
}

class ResourceTableCell: TableViewCell {

    struct Layout {
        struct CollectionView {
            static let collectionSize: CGSize           = .init(width: 1, height: 165)
            static let backgroundColor: UIColor         = .clear
            static let itemSize: CGSize                 = CGSize(width: 105, height: 150)
            static let minimumLineSpacing: CGFloat      = 10
            static let minimumInteritemSpacing: CGFloat = 10
            static let sectionInset: UIEdgeInsets       = .init(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
            static let itemIdentifier                   = ResourceItemCollectionCell.className
        }
    }

    private let collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let collectionViewLayout                     = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize                = Layout.CollectionView.itemSize
        collectionViewLayout.minimumLineSpacing      = Layout.CollectionView.minimumLineSpacing
        collectionViewLayout.minimumInteritemSpacing = Layout.CollectionView.minimumInteritemSpacing
        collectionViewLayout.scrollDirection         = .horizontal
        collectionViewLayout.sectionInset            = Layout.CollectionView.sectionInset
        return collectionViewLayout
    }()

    var collectionView: UICollectionView!
    var dataSource: [Genre]!
    weak var delegate: ResourceItemInteractionDelegate?
    
    override func prepareViews() {
        dataSource = []
        collectionView = .init(frame: .zero, collectionViewLayout: .init())
    }

    override func addViewHierarchy() {
        contentView.addSubview(collectionView)
        collectionView.register(ResourceItemCollectionCell.self, forCellWithReuseIdentifier: Layout.CollectionView.itemIdentifier)
    }

    override func setupConstraints() {
        activate(
            collectionView.anchor.edges.insets(.zero),
            collectionView.anchor.height.equal.to(Layout.CollectionView.collectionSize.height)
        )
    }

    override func configureViews() {
        selectionStyle                 = .none
        backgroundColor                = .lightGray
        collectionView.backgroundColor = Layout.CollectionView.backgroundColor
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.collectionViewLayout = collectionViewFlowLayout
        collectionView.dataSource      = self
        collectionView.delegate        = self
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        dataSource = []
    }
}

extension ResourceTableCell {
    func contructWith(items: [Genre]) {
        dataSource = items
        collectionView.reloadData()
    }
}

extension ResourceTableCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = dataSource[indexPath.row]
        let cell: ResourceItemCollectionCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        cell.configureWith(item: item)
        return cell
    }
}

extension ResourceTableCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = dataSource[indexPath.row]
        delegate?.didSelect(item: item)
    }
}
