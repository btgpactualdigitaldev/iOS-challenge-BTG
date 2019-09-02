//
//  NoContentView.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit
import Anchors

class NoContentView: View {

    var imageView: UIImageView
    var textLabel: UILabel

    override init(frame: CGRect) {
        imageView = .init()
        textLabel = .init()
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addViewHierarchy() {
        addSubviews([imageView, textLabel])
    }

    override func setupConstraints() {
        activate(
            imageView.anchor.centerX.equal.to(anchor.centerX),
            textLabel.anchor.paddingHorizontally(20),
            textLabel.anchor.top.equal.to(imageView.anchor.bottom).insets(20)
        )
    }

    override func prepareViews() {
        textLabel.font          = .boldSystemFont(ofSize: 20)
        textLabel.textColor     = .grayThemeColor
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.text          = "Hummm... Looks like you don't have favorites yet."
        imageView.image         = #imageLiteral(resourceName: "img_spider_man_3d")
    }
}
