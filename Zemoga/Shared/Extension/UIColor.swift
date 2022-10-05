//
//  UIColor.swift
//  Zemoga
//z
//  Created by Jorge Azurduy on 10/1/22.
//

import UIKit
import Foundation

extension UIColor {

    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16)/256.0
        let green = CGFloat((hex & 0xFF00) >> 8)/256.0
        let blue = CGFloat(hex & 0xFF)/256.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
