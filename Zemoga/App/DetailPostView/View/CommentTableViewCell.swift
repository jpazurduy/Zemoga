//
//  CommentTableViewCell.swift
//  Zemoga
//
//  Created by Jorge Azurduy on 10/2/22.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    // MARK: - Properties
    static let identifier = "commnetTableView"
    
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    // MARK: - Lifecicle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupInnerView()
        setupAuthorLabel()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Setup UI
    func setupInnerView() {
        innerView.backgroundColor = .gray.withAlphaComponent(0.1)
        innerView.corners(8)
    }
    
    func setupAuthorLabel() {
        authorLabel.backgroundColor = Color.secondary
        let bounds: CGRect = authorLabel.bounds
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: ([.topLeft, .topRight]), cornerRadii: CGSize(width: 5.0, height: 5.0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        authorLabel.layer.mask = maskLayer
    }

    func setupComment(comment: Comment){
        authorLabel.text = comment.email
        commentLabel.text = comment.body
    }
}
