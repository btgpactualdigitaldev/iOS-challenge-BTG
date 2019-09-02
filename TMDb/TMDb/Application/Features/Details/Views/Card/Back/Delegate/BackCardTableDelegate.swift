//
//  BackCardTableDelegate.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

class BackCardTableDelegate: NSObject, UITableViewDelegate {

    var dataSource: BackCardDataSource
    weak var delegate: SectionTableHeaderInteractionDelegate?

    init(dataSource: BackCardDataSource) {
        self.dataSource = dataSource
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section != 0 {
            return 50
        }
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionTableHeaderCell.className) as? SectionTableHeaderCell {
            let item = dataSource.getDataFor(section: section)
            headerView.constructWith(title: item.sectionTitle, isCollapsed: item.isCollapsed)
            headerView.section = section
            headerView.delegate = delegate
            return headerView
        }
        return .init()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.1) {
            cell.alpha = 0.0
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 1.0) {
            cell.alpha = 1.0
        }
    }
}
