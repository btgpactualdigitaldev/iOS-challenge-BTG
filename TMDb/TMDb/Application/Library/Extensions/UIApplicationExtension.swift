//
//  UIApplicationExtension.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

extension UIApplication {
    func getWindow() -> UIWindow? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        guard let window = appDelegate.window else {
            return nil
        }
        
        return window
    }
    
}
