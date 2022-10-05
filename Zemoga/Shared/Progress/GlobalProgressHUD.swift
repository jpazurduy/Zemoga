//
//  GlobalProgressHUD.swift
//  GenuBank
//
//  Created by Jorge Azurduy on 10/2/22.
//

import UIKit
import MBProgressHUD

class GlobalProgressHUD {

    // MARK: - Properties

    static private var hudCount: Int = 0

    static private let hud: MBProgressHUD = {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        //let window = UIApplication.shared.currentUIWindow()?.rootViewController
        //let window = UIWindowScene.windows.filter {$0.isKeyWindow}.first
        guard let window = window else {
            fatalError("Failed to find key window")
        }

        let globalHUD = MBProgressHUD(view: window)
        window.addSubview(globalHUD)

        return globalHUD
    }()

    // MARK: - Show & Hide
    static func show(loadingText: String? = "Loading") {

        hudCount += 1
        hud.label.text = loadingText
        hud.show(animated: true)
    }

    static func hide(all: Bool = false) {
        guard hudCount > 0 else { return }

        hudCount -= 1
        if all || hudCount == 0 {
            hud.hide(animated: true)
        }
    }
}
