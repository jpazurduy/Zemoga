//
//  NavigatorView.swift
//  GenuBank
//
//  Created by Jorge Azurduy on 10/1/22.
//

import UIKit
import Foundation

public class NavigatorView: UINavigationController {
 
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    public override var preferredStatusBarStyle : UIStatusBarStyle {

        if let topVC = viewControllers.last {
            return topVC.preferredStatusBarStyle
        }

        return .default
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
