//
//  FrontCardView.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit
import Anchors

class FrontCardView: View {

    var coverImageView: UIImageView!
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    var infoButton: UIButton!
    var item: Movie?

    init(_ item: Movie?) {
        self.item = item
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareViews() {
        infoButton       = .init(type: .infoDark)
        coverImageView   = .init()
        titleLabel       = .init()
        descriptionLabel = .init()
    }

    override func addViewHierarchy() {
        addSubviews([coverImageView, infoButton, titleLabel, descriptionLabel])
    }

    override func setupConstraints() {
        activate(
            infoButton.anchor.top.right.equal.to(anchor).insets(10),
            coverImageView.anchor.edges.insets(EdgeInsets(top: 0, left: 0, bottom: -60, right: 0)),
            titleLabel.anchor.top.equal.to(coverImageView.anchor.bottom).insets(8),
            titleLabel.anchor.paddingHorizontally(10),
            descriptionLabel.anchor.top.equal.to(titleLabel.anchor.bottom).insets(2),
            descriptionLabel.anchor.bottom.greaterThanOrEqual.to(anchor.bottom),
            descriptionLabel.anchor.paddingHorizontally(10)
        )
    }

    override func configureViews() {
        backgroundColor            = .grayThemeColor
        coverImageView.contentMode = .scaleAspectFill
        titleLabel.font            = .boldSystemFont(ofSize: 18)
        titleLabel.textColor       = .white
        descriptionLabel.font      = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .lightGray
        infoButton.tintColor       = .black
        
        layer.cornerRadius = 3.0
        clipsToBounds = true
    }

    override func configureBindings() {
        titleLabel.text = item?.title
        coverImageView.setImageFrom(url: item?.getPosterFullImagePath().absoluteString)
        if let updatedDate = item?.releaseDate?.toString(dateFormat: "dd MMM, yyyy") {
            descriptionLabel.text = "Released in \(updatedDate)."
        }
    }
}
