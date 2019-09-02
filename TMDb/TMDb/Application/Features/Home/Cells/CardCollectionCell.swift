//
//  CardCollectionCell.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit
import Anchors

class CardCollectionCell: CollectionViewCell {
    
    typealias FavoriteClosure = (_ item: Movie) -> Void
    private var block: FavoriteClosure?
    private var item: Movie!
    var cardImageView: UIImageView!
    var titleLabel: UILabel!
    var favoriteButton: UIButton!
    
    override func prepareViews() {
        item               = .init()
        cardImageView      = .init()
        titleLabel         = .init()
        favoriteButton     = .init()
    }

    override func addViewHierarchy() {
        contentView.addSubviews([
            cardImageView,
            titleLabel,
            favoriteButton
        ])
    }

    override func setupConstraints() {
        activate(
            cardImageView.anchor.top.left.right.bottom.equal.to(contentView.anchor),
            favoriteButton.anchor.right.top.equal.to(contentView.anchor).insets(10),
            titleLabel.anchor.paddingHorizontally(10),
            titleLabel.anchor.bottom.equal.to(contentView.anchor.bottom).insets(6)
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
        layoutIfNeeded()
        layer.cornerRadius          = 3.0
        clipsToBounds               = true
        contentView.backgroundColor = .grayThemeColor
        cardImageView.contentMode   = .scaleAspectFill
        titleLabel.font             = .systemFont(ofSize: 17)
        titleLabel.textColor        = .white
        titleLabel.numberOfLines    = 2
        favoriteButton.setImage(#imageLiteral(resourceName: "icon_favorite_no_selected"), for: .normal)
        favoriteButton.setImage(#imageLiteral(resourceName: "icon_favorite_selected"), for: .selected)
        cardImageView.addBlackGradientLayer()
        favoriteButton.addTarget(self, action: #selector(favoriteButtonPressed(_:)), for: .touchUpInside)
    }
    
    private func clean() {
        cardImageView.image = nil
        titleLabel.text = nil
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        item.isFavorite   = sender.isSelected
        block?(item)
    }
}

extension CardCollectionCell {
    func configureWith(item: Movie, favoriteHandler: @escaping FavoriteClosure) {
        self.item                 = item
        self.block                = favoriteHandler
        titleLabel.text           = self.item.title
        favoriteButton.isSelected = self.item.isFavorite
        cardImageView.setImageFrom(url: self.item.getPosterFullImagePath().absoluteString)
    }
}
