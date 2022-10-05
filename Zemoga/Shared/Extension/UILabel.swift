//
//  UILabel.swift
//  Zemoga
//
//  Created by Jorge Azurduy on 10/1/22.
//

import UIKit
import Foundation

extension UILabel {
    func setText(font: String, textColor: UIColor, size: CGFloat) {
        self.font = UIFont(name: font, size: size)
        self.textColor = textColor
    }
}
