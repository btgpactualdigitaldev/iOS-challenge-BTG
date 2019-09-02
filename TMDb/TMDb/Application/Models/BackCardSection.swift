//
//  BackCardSection.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import Foundation

class BackCardSection {
    var type: BackCardItemType
    var sectionTitle: String
    var isCollapsed: Bool
    var rowCount: Int {
        return 1
    }
    var isCollapsible: Bool {
        return true
    }

    init(type: BackCardItemType, sectionTitle: String, isCollapsed: Bool) {
        self.type         = type
        self.sectionTitle = sectionTitle
        self.isCollapsed  = isCollapsed
    }
}
