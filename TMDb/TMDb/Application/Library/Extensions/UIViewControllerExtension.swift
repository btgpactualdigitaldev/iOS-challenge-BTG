//
//  UIViewControllerExtension.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

extension UIViewController {
    fileprivate struct AssociatedObjectKeys {
        static var reachabilityView : UInt8 = 0
        static var reachabilityLastStatus : UInt8 = 0
    }
    
    fileprivate var lastReachabilityIsConnected: Bool? {
        get { return objc_getAssociatedObject(self, &AssociatedObjectKeys.reachabilityLastStatus) as? Bool }
        set { objc_setAssociatedObject(self, &AssociatedObjectKeys.reachabilityLastStatus, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    fileprivate var reachabilityView: UIView? {
        get { return objc_getAssociatedObject(self, &AssociatedObjectKeys.reachabilityView) as? UIView }
        set { objc_setAssociatedObject(self, &AssociatedObjectKeys.reachabilityView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func reachabilityView(hasConection: Bool) {
        if hasConection {
            if reachabilityView != nil {
                if lastReachabilityIsConnected == false {
                    UIView.animate(withDuration: 1.0, delay: 0.0, options: .transitionCrossDissolve, animations: { [weak self] in
                        guard let self = self else { return }
                        (self.reachabilityView?.subviews.filter({ $0 is UILabel }).first as? UILabel)?.text = "Conected"
                        self.reachabilityView?.backgroundColor = .greenConectionColor
                        self.reachabilityView?.alpha = 1.0
                    }) { _ in
                        UIView.animate(withDuration: 1.0, delay: 0.0, options: .transitionCurlUp, animations: { [weak self] in
                            guard let self = self else { return }
                            self.reachabilityView?.alpha = 0.0
                        }) { _ in
                            self.reachabilityView?.removeFromSuperview()
                        }
                    }
                }
                lastReachabilityIsConnected = hasConection
            }
        } else {
            if reachabilityView == nil {
                let label: UILabel  = .init(frame: .zero)
                label.textColor     = .white
                label.font          = .boldSystemFont(ofSize: 12.0)
                label.textAlignment = .center
                label.text = "No Conection"
                label.translatesAutoresizingMaskIntoConstraints = false
                
                reachabilityView = .init(frame: .zero)
                reachabilityView?.backgroundColor = .redConectionColor
                reachabilityView?.addSubview(label)
                reachabilityView?.translatesAutoresizingMaskIntoConstraints = false

                NSLayoutConstraint.activate([
                    label.leftAnchor.constraint(equalTo: reachabilityView!.leftAnchor),
                    label.rightAnchor.constraint(equalTo: reachabilityView!.rightAnchor),
                    label.topAnchor.constraint(equalTo: reachabilityView!.topAnchor),
                    label.bottomAnchor.constraint(equalTo: reachabilityView!.bottomAnchor)
                ])
                
            } else if view.subviews.contains(reachabilityView!) {
                if lastReachabilityIsConnected == true {
                    UIView.animate(withDuration: 1.0, delay: 0.0, options: .transitionCrossDissolve, animations: { [weak self] in
                        guard let self = self else { return }
                        (self.reachabilityView?.subviews.filter({ $0 is UILabel }).first as? UILabel)?.text = "No Conection"
                        self.reachabilityView?.backgroundColor = .redConectionColor
                        self.reachabilityView?.alpha = 1.0
                    }, completion: nil)
                }
                return
            }
            
            reachabilityView?.alpha = 0.0
            (reachabilityView?.subviews.filter({ $0 is UILabel }).first as? UILabel)?.text = "No Conection"
            reachabilityView?.backgroundColor = .redConectionColor
            
            view.addSubview(reachabilityView!)
            
            NSLayoutConstraint.activate([
                reachabilityView!.leftAnchor.constraint(equalTo: view.leftAnchor),
                reachabilityView!.rightAnchor.constraint(equalTo: view.rightAnchor),
                reachabilityView!.topAnchor.constraint(equalTo: view.topAnchor, constant: view.safeAreaInsets.top + 44),
                reachabilityView!.heightAnchor.constraint(equalToConstant: 20)
            ])
            
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .transitionCrossDissolve, animations: { [weak self] in
                guard let self = self else { return }
                self.reachabilityView?.alpha = 1.0
            }, completion: nil)

            lastReachabilityIsConnected = hasConection
        }
    }
}

extension UIViewController {
    func showSimpleAlert(title: String?, text: String?, cancelButtonTitle: String) {
        let alert : UIAlertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let action : UIAlertAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
