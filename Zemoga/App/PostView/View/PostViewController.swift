//
//  PostViewController.swift
//  Zemoga
//
//  Created by Jorge Azurduy on 10/1/22.
//

import UIKit

protocol PostViewCoordinatorDelegate: AnyObject {
    func goToDetailPost(post: Post)
}

class PostViewController: UIViewController {

    // MARK: - Properties
    
    var viewModel: PostViewModel!
    weak var delegateCoordinator: PostViewCoordinator?
    
    private var titleLabel: UILabel!
    private var removePostsButton: UIButton!
    private var postTableView: UITableView!
    private var refreshControl: UIRefreshControl!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PostViewModel()
        
        viewModel.delegate = self
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        GlobalProgressHUD.show()
        viewModel.requestPosts()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK: - Setup UI
    
    func setupUI() {
        view.backgroundColor = Color.secondary
        setupTitleView()
        setupRemovePostsButton()
        setupTableView()
    }
    
    func setupTitleView() {
        titleLabel = UILabel()
        titleLabel.text = "News"
        titleLabel.setText(font: FontManager.black, textColor: Color.white, size: 24)
        titleLabel.numberOfLines = 0

        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func setupRemovePostsButton() {
        removePostsButton = UIButton(frame: .zero)
        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium, scale: .default)
        let image = UIImage(systemName: "trash.circle", withConfiguration: config)
        removePostsButton.tintColor = Color.white
        removePostsButton.setImage(image, for: .normal)
        removePostsButton.titleLabel?.textAlignment = .right
        removePostsButton.addTarget(self, action: #selector(self.removePostAction(sender:)), for: .touchUpInside)
        
        view.addSubview(removePostsButton)
        removePostsButton.translatesAutoresizingMaskIntoConstraints = false
        removePostsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        removePostsButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        removePostsButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        removePostsButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func setupTableView() {
        postTableView = UITableView()
        postTableView.delegate = self
        postTableView.dataSource = self
        postTableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        postTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        postTableView.showsVerticalScrollIndicator = false
        postTableView.allowsSelection = true
        postTableView.rowHeight = UITableView.automaticDimension
        postTableView.estimatedRowHeight = UITableView.automaticDimension
        
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        postTableView.addSubview(refreshControl)

        view.addSubview(postTableView)
        postTableView.translatesAutoresizingMaskIntoConstraints = false
        postTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -16).isActive = true
        postTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        postTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        postTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    // MARK: - Action Button
    
    @objc private func refreshTableView() {
        refreshControl.beginRefreshing()
        viewModel.requestPosts()
    }
    
    @objc func removePostAction(sender: Any) {
        viewModel.posts.removeAll(where: { ($0 as! Post).isLiked == false })
        
        postTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension PostViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier) as! PostTableViewCell
        cell.setupPost(post: (viewModel.posts[indexPath.row] as! Post), likedPosts: viewModel.likedPosts)
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PostViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegateCoordinator?.goToDetailPost(post: (viewModel.posts[indexPath.row] as! Post))
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        postTableView.beginUpdates()
        viewModel.posts.remove(at: indexPath.row)
        postTableView.deleteRows(at: [indexPath], with: .fade)
        postTableView.endUpdates()
    }
}

// MARK: - PostViewModelDelegate
extension PostViewController: PostViewModelDelegate {
    func updateView() {
        defer { GlobalProgressHUD.hide() }
        
        viewModel.setLikedPosts()
        viewModel.sortedPosts()
        
        refreshControl.endRefreshing()
        postTableView.reloadData()
    }
    
    func showError(error: String) {
        defer { GlobalProgressHUD.hide() }
        
        DispatchQueue.main.async { [unowned self] in
            self.showAlertWithAction(title: "Information Message", message: "There was an problem trying to recieve the information please try again in or contact with the desktop service at support@service.com") { [unowned self] _ in
                self.postTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
}
// MARK: - DetailViewDelegate _
extension PostViewController: DetailViewDelegate {
    func isLiked(value: Bool, id: Int) {
        viewModel.likedPosts[id] = value
    }
}
