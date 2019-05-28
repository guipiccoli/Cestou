//
//  UIVIewExtension.swift
//  Confort
//
//  Created by Luiz Pedro Franciscatto Guerra on 14/05/19.
//  Copyright © 2019 ADABestGroup. All rights reserved.
//

import UIKit

extension UIView {

    func addShadowToView () {
        clipsToBounds = false
        layer.shadowOpacity = 0.20
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 1)
    }

}
