//
//  UIViewExtension.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { view in
            self.addSubview(view)
        }
    }
}

extension UIView {
    fileprivate struct AssociatedObjectKeys {
        static var activityIndicator: UInt8 = 0
    }
    
    fileprivate var activiyIndicator: UIActivityIndicatorView? {
        get { return objc_getAssociatedObject(self, &AssociatedObjectKeys.activityIndicator) as? UIActivityIndicatorView }
        set { objc_setAssociatedObject(self, &AssociatedObjectKeys.activityIndicator, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    fileprivate func setupActiviyIndicator() {
        if let act = activiyIndicator {
            if !subviews.contains(act) {
                addSubview(act)
                setupActivityConstraints()
            }
        } else {
            let actFrame = CGRect(x: 0, y: 0, width: 25, height: 25)
            activiyIndicator = UIActivityIndicatorView(frame: actFrame)
            activiyIndicator?.hidesWhenStopped = true
            addSubview(activiyIndicator!)
            setupActivityConstraints()
        }
    }
    
    fileprivate func setupActivityConstraints() {
        activiyIndicator?.translatesAutoresizingMaskIntoConstraints = false
        activiyIndicator?.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activiyIndicator?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func startActivity(with style: UIActivityIndicatorView.Style = .white) {
        setupActiviyIndicator()
        activiyIndicator?.activityIndicatorViewStyle = style
        activiyIndicator?.startAnimating()
    }
    
    func stopActivity() {
        activiyIndicator?.stopAnimating()
    }
}

extension UIView {
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        layer.add(animation, forKey: nil)
    }
}

extension UIView {
    func addBlackGradientLayer() {
        let width = self.bounds.width
        let height = self.bounds.height
        let sHeight: CGFloat = 60.0
        let shadow = UIColor.black.withAlphaComponent(0.7).cgColor

        let topImageGradient = CAGradientLayer()
        topImageGradient.frame = CGRect(x: 0, y: 0, width: width, height: sHeight)
        topImageGradient.colors = [shadow, UIColor.clear.cgColor]
        layer.insertSublayer(topImageGradient, at: 0)

        let bottomImageGradient = CAGradientLayer()
        bottomImageGradient.frame = CGRect(x: 0, y: height - sHeight, width: width, height: sHeight)
        bottomImageGradient.colors = [UIColor.clear.cgColor, shadow]
        layer.insertSublayer(bottomImageGradient, at: 0)
        layer.shouldRasterize = true
    }
}
