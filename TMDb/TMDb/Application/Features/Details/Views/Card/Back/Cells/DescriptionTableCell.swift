//
//  DescriptionTableCell.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit
import Anchors

class DescriptionTableCell: TableViewCell {

    var titleLabel: UILabel!
    var descriptionLabel: UILabel!

    override func prepareViews() {
        titleLabel = .init()
        descriptionLabel = .init()
    }

    override func addViewHierarchy() {
        contentView.addSubviews([titleLabel, descriptionLabel])
    }

    override func setupConstraints() {
        activate(
            titleLabel.anchor.top.equal.to(contentView.anchor.top).insets(20),
            titleLabel.anchor.paddingHorizontally(20),
            descriptionLabel.anchor.top.equal.to(titleLabel.anchor.bottom).insets(10),
            descriptionLabel.anchor.paddingHorizontally(20),
            descriptionLabel.anchor.bottom.equal.to(contentView.anchor.bottom).insets(20)
        )
    }

    override func configureViews() {
        selectionStyle           = .none
        titleLabel.font          = .boldSystemFont(ofSize: 18)
        titleLabel.numberOfLines = 0
        descriptionLabel.font    = .systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        backgroundColor          = .clear
    }
}

extension DescriptionTableCell {
    func constructWith(title: String?, description: String?) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
