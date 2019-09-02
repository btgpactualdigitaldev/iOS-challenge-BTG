//
//  SectionTableHeaderCell.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit
import Anchors

protocol SectionTableHeaderInteractionDelegate: class {
    func toggleSection(header: SectionTableHeaderCell, section: Int)
}

class SectionTableHeaderCell: TableViewHeaderFooterCell {

    var titleLabel: UILabel!
    var arrowImage: UIImageView!
    var section: Int = 0

    weak var delegate: SectionTableHeaderInteractionDelegate?

    override func prepareViews() {
        titleLabel = .init()
        arrowImage = .init()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapHeader)))
    }

    override func addViewHierarchy() {
        contentView.addSubviews([titleLabel, arrowImage])
    }

    override func setupConstraints() {
        activate(
            titleLabel.anchor.paddingVertically(5),
            titleLabel.anchor.paddingHorizontally(20),
            arrowImage.anchor.right.equal.to(contentView.anchor.right).insets(10),
            arrowImage.anchor.centerY.equal.to(titleLabel.anchor.centerY)
        )
    }

    override func configureViews() {
        contentView.backgroundColor = .chocolateCosmosThemeColor
        arrowImage.image = #imageLiteral(resourceName: "downArrowImg")
        titleLabel.font = .systemFont(ofSize: 18)
        titleLabel.textColor = .goldThemeColor
    }

    @objc private func didTapHeader() {
        delegate?.toggleSection(header: self, section: section)
    }

    func setCollapsed(collapsed: Bool) {
        arrowImage?.rotate(collapsed ? 0.0 : .pi)
    }
}

extension SectionTableHeaderCell {
    func constructWith(title: String?, isCollapsed: Bool) {
        titleLabel.text = title
        setCollapsed(collapsed: isCollapsed)
    }
}
