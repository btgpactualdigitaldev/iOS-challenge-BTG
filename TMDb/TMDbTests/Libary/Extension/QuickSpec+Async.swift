//
//  QuickSpec+Async.swift
//  TMDbTests
//
//  Created by Renato Machado Filho on 16/04/18.
//  Copyright © 2018 Renato Machado Filho. All rights reserved.
//

import Nimble
import Quick

/**
 Constants related to QuickSpec
 */
extension QuickSpec {
    /**
    Wait asynchronously until the done closure is called or the timeout has been reached
    */
    public func waitUntil(timeout: TimeInterval = 5, action: @escaping (@escaping () -> Void) -> Void) {
        Nimble.waitUntil(timeout: timeout, action: action)
    }
}
