//
//  DetailViewCoordinator.swift
//  Zemoga
//
//  Created by Jorge Azurduy on 10/2/22.
//

import UIKit
import Foundation

class DetailViewCoordinator: Coordinator {
    
    static let storyboard = "DetailView"
    private let navigationController: NavigatorView
    private var detailViewController: DetailViewController?
    private var postViewController: PostViewController!
    private var post: Post!
    
    init(navigationController: NavigatorView, post: Post, postViewController: PostViewController) {
        self.post = post
        self.postViewController = postViewController
        self.navigationController = navigationController
        self.navigationController.navigationBar.isHidden = true
        self.navigationController.toolbar.isHidden = true
    }
    
    func start() {
        let storyboard = UIStoryboard(name: DetailViewCoordinator.storyboard, bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: DetailViewController.identifier)
        if let detailViewController = view as? DetailViewController {
            detailViewController.delegateCoordinator = self
            detailViewController.delegateDetailView = self.postViewController
            detailViewController.viewModel = DetailViewModel(post: post)
            detailViewController.viewModel.delegate = detailViewController
            navigationController.pushViewController(detailViewController, animated: true)
            self.detailViewController = detailViewController
        }
    }
}

extension DetailViewCoordinator: DetailViewCoordinatorDelegate {
    func goBack() {
        self.navigationController.popViewController(animated: true)
    }
    
}
