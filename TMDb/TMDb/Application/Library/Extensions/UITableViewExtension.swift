//
//  UITableViewExtension.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withIdentifier: T.className, for: indexPath) as? T
        return cell.or(.init())
    }
}
