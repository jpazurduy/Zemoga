//
//  UIView.swift
//  Zemoga
//
//  Created by Jorge Azurduy on 10/1/22.
//

import UIKit
import Foundation

extension UIView {
    @discardableResult
    func corners(_ radius: CGFloat) -> UIView {
        layer.cornerRadius = radius
        layer.masksToBounds = false
        return self
    }
    
    @discardableResult
    func shadow(radius: CGFloat, color: UIColor, offset: CGSize, opacity: Float) -> UIView {
        layer.shadowRadius = radius
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        clipsToBounds = true
        return self
    }
}
