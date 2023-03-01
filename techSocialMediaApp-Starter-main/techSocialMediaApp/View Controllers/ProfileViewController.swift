//
//  ProfileViewController.swift
//  techSocialMediaApp
//
//  Created by Boe Bogdin on 2/1/23.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ConfirmDeletionAlertDelegate, UpdateCellProtocol, ReloadDelegate {
    
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var techInterestsTextView: UITextView!
    @IBOutlet weak var atLabel: UILabel!
    
    @IBOutlet weak var postsTableView: UITableView!
    
    var individualCellUpdate: Bool = false
    
    var userProfile = UserProfile(firstName: "", lastName: "", userName: "", userUUID: UUID(), posts: [Post]())
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        postsTableView.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        postsTableView.dataSource = self
        postsTableView.delegate = self
        
        getProfile()
        maskUserCircle()
        loadTopImage()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        postsTableView.addSubview(refreshControl)
        
//        postsTableView.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func refresh() {
        updateUI()
        refreshControl.endRefreshing()
    }
    
    func maskUserCircle() {
        let pic = profileImage
        pic?.contentMode = .scaleAspectFill
        pic?.layer.cornerRadius = (pic?.frame.height)! / 2
        pic?.layer.masksToBounds = false
        pic?.clipsToBounds = true
        pic?.image = UIImage(named: "Spider-Boe")
    }
    
    func loadTopImage() {
        topImage.contentMode = .scaleAspectFill
        topImage.image = UIImage(named: "Spider-man Background")
    }
    
    func loadInfo() {
        userNameLabel.text = "\(userProfile.firstName) \(userProfile.lastName)"
        atLabel.text = "@\(userProfile.userName)"
//        bioTextView.font = UIFont(name: atLabel.font!.fontName, size: 16)
        bioTextView.text = "Bio: \n\(userProfile.bio ?? "")"
//        techInterestsTextView.font = UIFont(name: atLabel.font!.fontName, size: 16)
        techInterestsTextView.text = "Tech Interests: \n\(userProfile.techInterests ?? "")"
    }
    
    func updateCell(_ cell: UITableViewCell) {
        let indexPath = postsTableView.indexPath(for: cell) ?? IndexPath(row: 0, section: 1)
        userProfile.posts.removeAll()
//        getPosts()
        postsTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func updateUI() {
//        posts.removeAll()
        getProfile()
        postsTableView.reloadData()
    }
    
    func confirmationAlert(postid: Int) {
        let confirmDeleteAlert = UIAlertController(title: "Confirmation", message: "Are you sure that you want to delete this post?", preferredStyle: .alert)
        
        confirmDeleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deletePost(postid: postid)
            print("Alert Delete Selected")
        }))
        confirmDeleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
//        confirmDeleteAlert.present(PostsTableViewController(), animated: true)
        
        self.present(confirmDeleteAlert, animated: true)
    }
    
    func likeButtonPressed(_ postid: Int, cell: UITableViewCell) {
        Task {
            do {
                // Make the API Call
//                print(User.current!.secret)
//                print("PostID: \(postid)")
                let response = try await UpdateLikesController().like(userSecret: User.current!.secret, postid: postid)
//                print(response.userLiked)
//                print(tableView.indexPath(for: cell))
                let indexPath: IndexPath = postsTableView.indexPath(for: cell)!
                userProfile.posts[postsTableView.indexPath(for: cell)!.row] = response
                postsTableView.reloadRows(at: [indexPath], with: .none)
                
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func deletePost(postid: Int) {
        Task {
            do {
                // Make the API Call
//                print(User.current!.secret)
//                print("PostID: \(postid)")
                let success = try await DeletePostController().deletePost(userSecret: User.current!.secret, postid: postid)
                self.updateUI()
//                posts.append(contentsOf: postsResponse)
//                print(posts.count)
//                print(posts[0].body)
//                tableView.reloadData()
                updateUI()
                
            } catch {
                print("Error: \(error)")
//                errorLabel.text = "Invalid Username or Password"
            }
        }
    }
    
    func getProfile() {
        Task {
            do {
                // Make the API Call
                let profileResponse = try await GetProfileController().getProfile(userUUID: User.current!.userUUID, userSecret: User.current!.secret)
                
                userProfile = profileResponse
                loadInfo()
                postsTableView.reloadData()
                
            } catch {
                print(error)
//                errorLabel.text = "Invalid Username or Password"
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userProfile.posts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "profileCommentSegue", sender: self)
        postsTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postsTableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! UserPostsTableViewCell
        
        let post = userProfile.posts[indexPath.row]
        
        cell.delegate = self
        cell.reloadDelegate = self
        
        cell.usernameLabel.text = "@\(post.authorUserName)"
        cell.postBodyLabel.text = post.body
        cell.postTitleLabel.text = post.title
        cell.postTitleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        cell.dateCreatedLabel.text = post.createdDate
        cell.commentsButton.titleLabel?.text = "\(post.numComments)"
        cell.likeButton.titleLabel?.text = "\(post.likes)"
        
        cell.userId = post.authorUserId
        cell.postid = post.postid
//        print(cell.postid)
//        print("self is \(cell) and postID is \(post.postid) display at index \(indexPath)")
        
//        cell.showTrashButton()
        cell.commentsNum.append(post.numComments)
        cell.likesNum.append(post.likes)
        
        if post.userLiked {
            cell.likeButton.tintColor = .red
            cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            cell.likeButton.tintColor = .tintColor
            cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        if cell.commentsNum.count > 1 {
            cell.commentsNum.removeFirst()
        }
        if cell.likesNum.count > 1 {
            cell.likesNum.removeFirst()
        }
        cell.loadLikeAndCommentNum()
        
        cell.commentsButton.tag = indexPath.row
        cell.editButton.tag = indexPath.row
        
//        postsTableView.reloadData()
//        tableView.reloadData()
        
        return cell
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        switch segue.identifier {
        case "profileCommentSegue":
            let commentsVC = segue.destination as! CommentsTableViewController
            //            let commentsVC = nvc.viewControllers.first as! CommentsTableViewController
            
            commentsVC.postid = userProfile.posts[postsTableView.indexPathForSelectedRow!.row].postid
            commentsVC.ogPoster = userProfile.posts[postsTableView.indexPathForSelectedRow!.row].authorUserName
        case "editProfileSegue":
            let editVC = segue.destination as! EditProfileTableViewController
            
            editVC.delegate = self
            editVC.user = self.userProfile
        case "createCommentSegue":
            let button = sender as! UIButton
            let indexPathRow = button.tag
            
            let commentsVC = segue.destination as! CreatePostTableViewController
            
            commentsVC.postUsername = userProfile.posts[indexPathRow].authorUserName
            commentsVC.isComment = true
            commentsVC.postid = userProfile.posts[indexPathRow].postid
            commentsVC.delegate = self
        case "editPostSegue":
            let button = sender as! UIButton
            let indexPathRow = button.tag
            
            let editVC = segue.destination as! CreatePostTableViewController
            
//            editVC.post.removeFirst(1)
            editVC.post.append(userProfile.posts[indexPathRow])
//            editVC.post = posts[indexPathRow]
            editVC.postid = userProfile.posts[indexPathRow].postid
//            print(posts[indexPathRow].postid)
            editVC.isComment = false
            editVC.isEdit = true
            editVC.delegate = self
        default:
            break
        }
    }
    
    
    @IBAction func editProfileButtonPressed(_ sender: Any) {
    }
    
    
    
    

}
