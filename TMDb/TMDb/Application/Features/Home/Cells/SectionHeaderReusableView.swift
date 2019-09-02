//
//  SectionHeaderReusableView.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit
import Anchors

class SectionHeaderReusableView: CollectionReusableView {
    var titleLabel: UILabel!

    override func prepareViews() {
        titleLabel = .init()
    }

    override func addViewHierarchy() {
        addSubview(titleLabel)
    }

    override func setupConstraints() {
        activate(
            titleLabel.anchor.edges.insets(EdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
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
        titleLabel.font      = .boldSystemFont(ofSize: 17)
        titleLabel.textColor = .white
    }

    private func clean() {
        titleLabel.text = nil
    }
}
