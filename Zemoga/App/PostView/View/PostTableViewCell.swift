//
//  PostTableViewCell.swift
//  Zemoga
//
//  Created by Jorge Azurduy on 10/1/22.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    // MARK: - Properties
    static let identifier = "postsCellId"
    
    private var idCell: Int!
    private var cardView :UIView!
    private var titleLabel: UILabel!
    private var bodyLabel: UILabel!
    private var starImage: UIImageView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCardView()
        setTitleLabel()
        setupStarImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Setup UI
    func setupCardView() {
        cardView = UIView()
        cardView.corners(12)
        self.contentView.addSubview(cardView)

        cardView.backgroundColor = .gray.withAlphaComponent(0.1)
        
        cardView.layer.borderWidth = 0.5
        cardView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor

        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
        cardView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        cardView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        cardView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    func setTitleLabel() {
        titleLabel = UILabel()
        titleLabel.setText(font: FontManager.bold, textColor: Color.font.withAlphaComponent(0.7), size: 14)
        titleLabel.numberOfLines = 0

        cardView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -35).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16).isActive = true
    }
    
    func setupStarImage() {
        starImage = UIImageView(image: UIImage(systemName: "star"))
        
        cardView.addSubview(starImage)
        starImage.translatesAutoresizingMaskIntoConstraints = false
        starImage.centerYAnchor.constraint(equalTo: cardView.centerYAnchor, constant: 0).isActive = true
        starImage.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16).isActive = true
        starImage.widthAnchor.constraint(equalToConstant: 16).isActive = true
        starImage.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }
    
    func setupPost(post: Post, likedPosts: [Int: Bool]) {
        idCell = post.id
        titleLabel.text = post.title?.uppercased()
  
        if post.isLiked {
            starImage.image = UIImage(systemName: "star.fill")
        } else {
            starImage.image = UIImage(systemName: "star")
        }
        
    }
}
