//
//  UITextFieldExtension.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//
import UIKit

extension UITextField {
    fileprivate struct AssociatedObjectKeys {
        static var toolBarIsEnable : UInt8 = 0
        static var toolBarView: UInt8 = 1
    }
    
    fileprivate var toolBar: UIToolbar? {
        get { return objc_getAssociatedObject(self, &AssociatedObjectKeys.toolBarView) as? UIToolbar }
        set { objc_setAssociatedObject(self, &AssociatedObjectKeys.toolBarView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    var enableToolBar: Bool {
        get { return (objc_getAssociatedObject(self, &AssociatedObjectKeys.toolBarIsEnable) as? Bool) ?? false }
        set {
            if newValue {
                if toolBar == nil {
                    let toolBarFrame: CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50.0)
                    toolBar = UIToolbar(frame: toolBarFrame)
                    toolBar?.barStyle = .default
                    
                    let cancelButton: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(toolBarCancelButtonAction(_:)))
                    let flexibleSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
                    
                    cancelButton.tintColor = UIColor.black
                    cancelButton.setTitleTextAttributes([.foregroundColor: UIColor.black], for: UIControlState())
                    toolBar?.items = [flexibleSpace, cancelButton]
                }
                inputAccessoryView = toolBar
            } else {
                inputAccessoryView = nil
            }
            objc_setAssociatedObject(self, &AssociatedObjectKeys.toolBarIsEnable, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc final fileprivate func toolBarCancelButtonAction(_ sender: UIBarButtonItem) {
        resignFirstResponder()
    }
}
