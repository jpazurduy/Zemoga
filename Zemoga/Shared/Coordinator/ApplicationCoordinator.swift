//
//  ApplicationCoordinator.swift
//  GenuBank
//
//  Created by Jorge Azurduy on 10/1/22.
//

import UIKit
import Foundation
 
class ApplicationCoordinator: Coordinator {

  let window: UIWindow
  let navigationController: NavigatorView
  let postViewCoordinator: PostViewCoordinator

  init(window: UIWindow) {
    self.window = window
      navigationController = NavigatorView()
      navigationController.navigationBar.isHidden = true
      postViewCoordinator = PostViewCoordinator(navigationController: navigationController)
  }

  func start() {
    window.rootViewController = navigationController
    postViewCoordinator.start()
    window.makeKeyAndVisible()
  }
}
