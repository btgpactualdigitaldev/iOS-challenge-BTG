//
//  UIImageViewExtension.swift
//  TMDb
//
//  Created by Renato De Souza Machado Filho on 04/08/19.
//  Copyright © 2019 Renato Machado Filho. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    func setImageFrom(url: String?) {
        guard let urlUnwrapped = url, let urlImage = URL(string: urlUnwrapped) else {
            image = nil
            return
        }
        
        startActivity()
        sd_setImage(with: urlImage) { [weak self] (image, error, _, _) in
            self?.stopActivity()
            self?.image = image
        }
    }
}
