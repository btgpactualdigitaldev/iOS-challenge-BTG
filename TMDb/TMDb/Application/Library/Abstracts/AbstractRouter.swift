//
//  AbstractRouter.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

class AbstractRouter: NSObject {
    
    weak var rootViewController: UIViewController?
    
    required init(rootViewController: UIViewController?) {
        super.init()
        self.rootViewController = rootViewController
    }

    class func viewController() -> UIViewController { fatalError() }
    
    func onSessionError() {}
    
    func goBackView() {
        self.rootViewController!.navigationController!.popViewController(animated: true)
    }
    
    func goDismiss() {
        self.rootViewController!.dismiss(animated: true, completion: nil)
    }
}
