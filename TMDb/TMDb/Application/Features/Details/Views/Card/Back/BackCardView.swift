//
//  BackCardView.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit
import Anchors

class BackCardView: View {

    var tableView: UITableView!
    var backButton: UIButton!
    var backCardDataSource: BackCardDataSource
    var backCardDelegate: BackCardTableDelegate

    init(_ item: Movie?, delegate: ResourceItemInteractionDelegate?) {
        backCardDataSource = .init(item)
        backCardDelegate   = .init(dataSource: backCardDataSource)
        super.init(frame: .zero)
        backCardDelegate.delegate = self
        backCardDataSource.delegate = delegate
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareViews() {
        tableView  = .init()
        backButton = .init()
    }

    override func addViewHierarchy() {
        addSubviews([tableView, backButton])
        tableView.register(DescriptionTableCell.self, forCellReuseIdentifier: DescriptionTableCell.className)
        tableView.register(ResourceTableCell.self, forCellReuseIdentifier: ResourceTableCell.className)
        tableView.register(SectionTableHeaderCell.self, forHeaderFooterViewReuseIdentifier: SectionTableHeaderCell.className)
    }

    override func setupConstraints() {
        activate(
            backButton.anchor.top.right.equal.to(anchor).insets(10),
            backButton.anchor.size.equal.to(.init(25)),
            tableView.anchor.top.left.right.bottom.equal.to(self.anchor)
        )
    }

    override func configureViews() {
        backgroundColor          = .lightGray
        layer.cornerRadius       = 3.0
        clipsToBounds            = true

        tableView.delegate       = backCardDelegate
        tableView.dataSource     = backCardDataSource
        tableView.estimatedRowHeight = 100
        tableView.rowHeight      = UITableViewAutomaticDimension
        tableView.separatorInset = .zero
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = .init()
        tableView.backgroundColor = .lightGray

        backButton.tintColor      = .black
        backButton.setImage(#imageLiteral(resourceName: "icon_reply"), for: .normal)
    }

    func updateUI() {
        tableView.reloadData()
    }
}

extension BackCardView: SectionTableHeaderInteractionDelegate {
    func toggleSection(header: SectionTableHeaderCell, section: Int) {
        let item = backCardDataSource.getDataFor(section: section)
        if item.isCollapsible {
            let collapsed = !item.isCollapsed
            item.isCollapsed = collapsed
            header.setCollapsed(collapsed: collapsed)
            
            tableView.beginUpdates()
            if item.isCollapsed {
                tableView.deleteRows(at: [.init(row: 0, section: section)], with: .right)
            } else {
                tableView.insertRows(at: [.init(row: 0, section: section)], with: .right)
            }
            tableView.endUpdates()
        }
    }
}
