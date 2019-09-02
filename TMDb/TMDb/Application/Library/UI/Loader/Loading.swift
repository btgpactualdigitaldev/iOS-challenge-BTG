//
//  LoadingOverlay.swift
//  TMDb
//
//  Created by Renato Machado Filho on 09/04/18.
//  Copyright © 2018 Renato Machado Filho. All rights reserved.
//

import UIKit

class Loading: UIView {

    static let shared: Loading = Loading()
    private var overlayView : Loading! = nil
    private var activityIndicator = UIActivityIndicatorView()

    func showLoading() {
        if let win = UIApplication.shared.getWindow(), !win.subviews.contains(where: { $0 is Loading }) {
            overlayView = Loading(frame: win.bounds)
            overlayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
            overlayView.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
            overlayView.activityIndicator.startAnimating()
            overlayView.activityIndicator.center = overlayView.center
            overlayView.addSubview(overlayView.activityIndicator)
            win.addSubview(overlayView)
        }
    }

    func hideLoading() {
        if overlayView != nil {
            overlayView.activityIndicator.stopAnimating()
            overlayView.removeFromSuperview()
        }
    }
}
