//
//  PostTableViewCell.swift
//  Tech Social
//
//  Created by Boe Bogdin on 11/3/22.
//

import UIKit

protocol ConfirmDeletionAlertDelegate {
    func confirmationAlert(postid: Int)
    func likeButtonPressed(_ postid: Int, cell: UITableViewCell)
}

protocol UpdateCellProtocol {
    func updateCell(_ cell: UITableViewCell)
    var individualCellUpdate: Bool { get set }
}

protocol EditPostDelegate {
    func editPost(postid: Int)
}

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postAuthorUserNameLabel: UILabel!
    @IBOutlet weak var postBodyLabel: UILabel!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var likesButton: UIButton!
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
        loadLikeAndCommentNum()
//        print(userId)
        showEditButton()
        showTrashButton()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func changeHeart() {
        if likesButton.imageView?.image == UIImage(systemName: "heart") {
            likesButton.imageView?.image = UIImage(systemName: "heart.fill")
            likesButton.tintColor = .tintColor
        } else {
            likesButton.imageView?.image = UIImage(systemName: "heart")
            likesButton.tintColor = .red
        }
    }
    
    func showTrashButton() {
        if userId == User.current?.userUUID {
            trashButton.isEnabled = true
            trashButton.tintColor = .systemRed
            trashButton.alpha = 1
            
            editButton.isEnabled = true
            editButton.tintColor = .tintColor
            editButton.alpha = 1
        } else {
            trashButton.isEnabled = false
            trashButton.tintColor = .clear
            trashButton.alpha = 0
            
            editButton.isEnabled = false
            editButton.tintColor = .clear
            editButton.alpha = 0
        }
//        print(userId)
    }
    
    func showEditButton() {
        if userId == User.current?.userUUID {
//            print("Show edit button")
            editButton.isEnabled = true
            editButton.tintColor = .tintColor
            editButton.alpha = 1
        } else {
//            print("Don't show edit button")
            editButton.isEnabled = false
//            editButton.tintColor = .clear
            editButton.alpha = 0
        }
//        print(userId)
    }
    
    func loadLikeAndCommentNum() {
        
//        print(likesNum)
        likesButton.setTitle("\(likesNum[0])", for: .normal)
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
    
    @IBAction func editButtonPressed(_ sender: Any) {
    }
    
}
