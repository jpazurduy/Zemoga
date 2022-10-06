//
//  UIViewController.swift
//  Zemoga
//
//  Created by Jorge Azurduy on 10/3/22.
//

import UIKit
import Foundation

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showAlertWithAction(title: String, message: String, _ action:((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: action))
        self.present(alert, animated: true)
    }
}
