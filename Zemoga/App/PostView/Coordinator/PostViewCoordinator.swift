//
//  PostViewCoordinator.swift
//  Zemoga
//
//  Created by Jorge Azurduy on 10/1/22.
//

import UIKit
import Foundation

class PostViewCoordinator: Coordinator {
    
    static let storyboard = "DetailView"
    private let navigationController: NavigatorView
    private var postViewController: PostViewController?
    private var detailViewCoordinator: DetailViewCoordinator!
    private var detailViewController: DetailViewController!
    
    init(navigationController: NavigatorView) {
        self.navigationController = navigationController
    }

    func start() {
        let postViewController = PostViewController()
        postViewController.delegateCoordinator = self
        navigationController.pushViewController(postViewController, animated: true)
        self.postViewController = postViewController
    }
}

extension PostViewCoordinator: PostViewCoordinatorDelegate {
    func goToDetailPost(post: Post) {
        let detailViewCoordinator = DetailViewCoordinator(navigationController: navigationController, post: post, postViewController: self.postViewController!)
        detailViewCoordinator.start()
        self.detailViewCoordinator = detailViewCoordinator
    }
}
