//
//  BannerCollectionCell.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit
import Anchors

class BannerCollectionCell: CollectionViewCell {

    var gradientView: UIView!
    var slideShowImage: ImageSlideshow!
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    private var items: [Movie]!

    override func prepareViews() {
        items               = []
        gradientView        = .init()
        slideShowImage      = .init()
        titleLabel          = .init()
        descriptionLabel    = .init()
    }

    override func addViewHierarchy() {
        contentView.addSubviews([
            slideShowImage,
            gradientView,
            titleLabel,
            descriptionLabel
        ])
    }

    override func setupConstraints() {
        activate(
            slideShowImage.anchor.top.bottom.left.right.equal.to(contentView.anchor),
            gradientView.anchor.top.bottom.left.right.equal.to(contentView.anchor),
            descriptionLabel.anchor.bottom.equal.to(contentView.anchor.bottom).insets(20),
            descriptionLabel.anchor.paddingHorizontally(10),
            descriptionLabel.anchor.left.right.apply(to: [titleLabel]),
            titleLabel.anchor.bottom.equal.to(descriptionLabel.anchor.top).insets(4)
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
        layer.cornerRadius = 3.0
        clipsToBounds      = true

        gradientView.backgroundColor = .clear
        gradientView.addBlackGradientLayer()
        
        titleLabel.font              = .boldSystemFont(ofSize: 17)
        titleLabel.textColor         = .goldThemeColor
        descriptionLabel.font        = .boldSystemFont(ofSize: 14)
        descriptionLabel.textColor   = .white
        
        slideShowImage.backgroundColor                           = .clear
        slideShowImage.pageControlPosition                       = .insideScrollView
        slideShowImage.pageControl.currentPageIndicatorTintColor = .black
        slideShowImage.pageControl.pageIndicatorTintColor        = .gray
        slideShowImage.contentScaleMode                          = .scaleAspectFill
        slideShowImage.slideshowInterval                         = 3.0
        slideShowImage.zoomEnabled                               = false
        slideShowImage.currentPageChanged = { [weak self] index in
            guard let self = self else { return }
            self.titleLabel.text = self.items[index].title
        }
    }
    
    private func clean() {
        titleLabel.text = nil
        descriptionLabel.text = nil
        slideShowImage.slideshowItems.forEach { (imgShowItem) in
            imgShowItem.imageView.image = nil
        }
    }
    
    func configureWith(items: [Movie]) {
        self.items = items
        titleLabel.text = self.items.first?.title
        
        let urls: [URL] = self.items.compactMap({ $0.getPosterFullImagePath() })
        let inputSourcers: [InputSource] = urls.compactMap({ ResourceImage(url: $0)} )
        slideShowImage.setImageInputs(inputSourcers)
    }
}
