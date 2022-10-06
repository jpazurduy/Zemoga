//
//  DetailViewController.swift
//  Zemoga
//
//  Created by Jorge Azurduy on 10/2/22.
//

import UIKit

protocol DetailViewDelegate: AnyObject {
    func isLiked(value: Bool, id: Int)
}

protocol DetailViewCoordinatorDelegate: AnyObject {
    func goBack()
}

class DetailViewController: UIViewController {

    // MARK: - Properties
    static let identifier = "detailView"
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var likeContainer: UIView!
    @IBOutlet weak var likeThumbImage: UIImageView!
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var commentsTableView: UITableView!
    
    var viewModel: DetailViewModel!
    weak var delegateCoordinator: DetailViewCoordinatorDelegate?
    weak var delegateDetailView: DetailViewDelegate!
    
    // MARK: - Lifecicle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GlobalProgressHUD.show()
        viewModel.requestAuthor(authorId: viewModel.post.userId)
    }
    
    // MARK: - Setup UI
    
    func setupUI() {
        
        setupPostTitle()
        setupPostDescription()
        setupLikeIcon()
        setupLikeButtonContainer()
        setupTableViewContainer()
        setupTableView()
        setupPostAuthor()
        setupPostUsername()
    }
    
    func setupPostTitle() {
        postTitleLabel.setText(font: FontManager.black, textColor: Color.primary, size: 18)
        postTitleLabel.text = viewModel.post.title?.uppercased()
    }
    
    func setupPostDescription() {
        bodyLabel.setText(font: FontManager.regular, textColor: Color.black, size: 16)
        bodyLabel.text = viewModel.post.body
    }
    
    func setupPostAuthor() {
        authorNameLabel.setText(font: FontManager.bold, textColor: Color.black, size: 14)
    }
    
    func setupPostUsername() {
        userNameLabel.setText(font: FontManager.bold, textColor: Color.black, size: 14)
    }
    
    func setupLikeIcon() {
        if viewModel.post.isLiked {
            likeThumbImage.image = UIImage(systemName: "hand.thumbsup.fill")
        } else {
            likeThumbImage.image = UIImage(systemName: "hand.thumbsup")
        }
    }
    
    func setupLikeButtonContainer() {
        likeContainer.backgroundColor = Color.secondary
        likeContainer.corners(8)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.likePost))
        likeContainer.addGestureRecognizer(gesture)
        likeContainer.isUserInteractionEnabled = true
    }
    
    func setupTableViewContainer() {
        tableViewContainer.backgroundColor = Color.white
        tableViewContainer.corners(12)
    }
    
    func setupTableView() {
        commentsTableView.dataSource = self
        commentsTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        commentsTableView.showsVerticalScrollIndicator = false
        commentsTableView.allowsSelection = true
        commentsTableView.rowHeight = UITableView.automaticDimension
        commentsTableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    // MARK: - Action Button
    @IBAction func goBack(_ sender: Any) {
        delegateCoordinator?.goBack()
    }
   
    @objc func likePost() {
        if viewModel.post.isLiked {
            likeThumbImage.image = UIImage(systemName: "hand.thumbsup")
            delegateDetailView.isLiked(value: false, id: viewModel.post.id)
        } else {
            likeThumbImage.image = UIImage(systemName: "hand.thumbsup.fill")
            delegateDetailView.isLiked(value: true, id: viewModel.post.id)
        }
    }
}

// MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier) as! CommentTableViewCell
        cell.setupComment(comment: viewModel.comments[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - DetailViewModelDelegate
extension DetailViewController: DetailViewModelDelegate {
    func updateView(author: Author) {
        defer { GlobalProgressHUD.hide() }
        
        authorNameLabel.text = author.name
        userNameLabel.text = author.username
        
        GlobalProgressHUD.show()
        viewModel.requestComments(postId: viewModel.post.id)
    }
    
    func updateView(comments: [Comment]) {
        defer { GlobalProgressHUD.hide() }
        
        commentsTableView.reloadData()
    }
    
    func showError(error: String) {
        defer { GlobalProgressHUD.hide() }
        
        self.showAlert(title: "Information Message", message: "There was an problem trying to recieve the information please try again in or contact with the desktop service at support@service.com")
    }
}
