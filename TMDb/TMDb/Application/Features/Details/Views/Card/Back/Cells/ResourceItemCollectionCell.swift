//
//  ResourceItemCollectionCell.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit
import Anchors

class ResourceItemCollectionCell: CollectionViewCell {
    var coverImageView: UIImageView!
    var titleLabel: UILabel!

    override func prepareViews() {
        coverImageView = .init()
        titleLabel      = .init()
    }

    override func addViewHierarchy() {
        contentView.addSubviews([coverImageView, titleLabel])
    }

    override func setupConstraints() {
        activate(
            coverImageView.anchor.top.left.right.bottom.equal.to(contentView.anchor),
            titleLabel.anchor.left.right.top.bottom.equal.to(contentView.anchor)
        )
    }

    override func configureViews() {
        clean()
        setup()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        clean()
    }

    private func setup() {
        layer.cornerRadius          = 3.0
        clipsToBounds               = true
        contentView.backgroundColor = .grayThemeColor
        coverImageView.contentMode  = .scaleAspectFill
        titleLabel.font              = .systemFont(ofSize: 16)
        titleLabel.textAlignment     = .center
        titleLabel.textColor         = .white
        titleLabel.isHidden          = true
        titleLabel.numberOfLines     = 0
    }

    private func clean() {
        coverImageView.image = nil
        titleLabel.isHidden   = true
        titleLabel.text       = nil
    }
}

extension ResourceItemCollectionCell {
    func configureWith(item: Genre) {
        titleLabel.text = item.name
        titleLabel.isHidden = false
    }
}
