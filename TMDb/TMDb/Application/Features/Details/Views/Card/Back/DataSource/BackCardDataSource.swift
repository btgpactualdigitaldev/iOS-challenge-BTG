//
//  BackCardDataSource.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

class BackCardDataSource: NSObject {

    var data: [BackCardSection]!
    weak var delegate: ResourceItemInteractionDelegate?

    init(_ item: Movie?) {
        data = []

        let item0: BackCardItemType = .introduction(name: item?.title, description: item?.overview)
        data.append(.init(type: item0, sectionTitle: "", isCollapsed: false))

        if let genres = item?.genres, genres.count > 0 {
            let item: BackCardItemType = .genres(genres)
            data.append(.init(type: item, sectionTitle: "Genres", isCollapsed: true))
        }
    }

    func getDataFor(section: Int) -> BackCardSection {
        return data[section]
    }
}

extension BackCardDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = data[section]
        guard item.isCollapsible else {
            return item.rowCount
        }

        if item.isCollapsed {
            return 0
        } else {
            return item.rowCount
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch data[indexPath.section].type {
        case .introduction(let title, let overview):
            let cell: DescriptionTableCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.constructWith(title: title, description: overview)
            return cell
        case .genres(let genres):
            let cell: ResourceTableCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.contructWith(items: genres)
            cell.delegate = delegate
            cell.alpha = 0.0
            return cell
        }
    }
}
