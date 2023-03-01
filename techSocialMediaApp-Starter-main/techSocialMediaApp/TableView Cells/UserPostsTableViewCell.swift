//
//  UserPostsTableViewCell.swift
//  techSocialMediaApp
//
//  Created by Boe Bogdin on 2/3/23.
//

import UIKit

class UserPostsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postBodyLabel: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    var commentsNum: [Int] = [0]
    var likesNum: [Int] = [0]
    var postid: Int = 0
    var userId: UUID = UUID()
    
    var delegate: ConfirmDeletionAlertDelegate?
    var reloadDelegate: UpdateCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func changeHeart() {
        if likeButton.imageView?.image == UIImage(systemName: "heart") {
            likeButton.imageView?.image = UIImage(systemName: "heart.fill")
            likeButton.tintColor = .tintColor
        } else {
            likeButton.imageView?.image = UIImage(systemName: "heart")
            likeButton.tintColor = .red
        }
    }
    
    func showTrashButton() {
        if userId == User.current?.userUUID {
            trashButton.isEnabled = true
            trashButton.tintColor = .systemRed
            trashButton.alpha = 1
        } else {
            trashButton.isEnabled = false
            trashButton.tintColor = .clear
            trashButton.alpha = 0
        }
//        print(userId)
    }
    
    func loadLikeAndCommentNum() {
        
//        print(likesNum)
        likeButton.setTitle("\(likesNum[0])", for: .normal)
        commentsButton.setTitle("\(commentsNum[0])", for: .normal)
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        loadLikeAndCommentNum()
//        print("Cell postid: \(postid)")
        delegate?.likeButtonPressed(postid, cell: self)
        reloadDelegate?.individualCellUpdate = true
//        reloadDelegate?.updateCell(self)
//        changeHeart()
    }
    
    @IBAction func commentsButtonPressed(_ sender: Any) {
        loadLikeAndCommentNum()
    }
    
    @IBAction func trashButtonPressed(_ sender: Any) {
//        print(postid)
        delegate?.confirmationAlert(postid: postid)
    }
    
}
