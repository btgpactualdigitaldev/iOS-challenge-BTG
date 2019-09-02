//
//  UpcomingWidgetCollectionCell.swift
//  HeroesOfTheDay
//
//  Created by Renato De Souza Machado Filho on 06/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit
import Anchors

class UpcomingWidgetCollectionCell: CollectionViewCell {
    var coverImageView: UIImageView!
    var titleLabel: UILabel!

    override func prepareViews() {
        coverImageView = .init()
        titleLabel      = .init()
    }

    override func addViewHierarchy() {
        contentView.addSubviews([
            coverImageView,
            titleLabel
        ])
    }

    override func setupConstraints() {
        activate(
            coverImageView.anchor.top.left.right.bottom.equal.to(contentView.anchor),
            titleLabel.anchor.bottom.left.right.equal.to(contentView.anchor).insets(8)
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

    override func layoutSubviews() {
        super.layoutSubviews()
        let gradientLayers = coverImageView.layer.sublayers?.filter({ $0 is CAGradientLayer })
        let top            = gradientLayers?.max(by: { $0.frame.origin.y > $1.frame.origin.y })
        let bottom         = gradientLayers?.max(by: { $0.frame.origin.y < $1.frame.origin.y })
        top?.frame         = .init(x: 0, y: 0, width: frame.width, height: 60)
        bottom?.frame      = .init(x: 0, y: frame.height - 60, width: frame.width, height: 60)
    }

    private func setup() {
        layoutIfNeeded()
        layer.cornerRadius             = 8.0
        clipsToBounds                  = true
        contentView.backgroundColor    = .grayThemeColor
        titleLabel.font                = .boldSystemFont(ofSize: 14)
        titleLabel.textColor           = .white
        coverImageView.contentMode     = .scaleAspectFill
        coverImageView.backgroundColor = .lightGray
        coverImageView.addBlackGradientLayer()
    }

    private func clean() {
        coverImageView.image = nil
        titleLabel.text      = nil
    }
}

extension UpcomingWidgetCollectionCell {
    func configureWith(item: Movie) {
        titleLabel.text = item.title
        coverImageView.setImageFrom(url: item.getPosterFullImagePath().absoluteString)
    }
}
