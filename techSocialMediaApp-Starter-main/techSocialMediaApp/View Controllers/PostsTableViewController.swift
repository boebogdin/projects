//
//  PostsTableViewController.swift
//  Tech Social
//
//  Created by Boe Bogdin on 11/3/22.
//

import UIKit

class PostsTableViewController: UITableViewController, ConfirmDeletionAlertDelegate, ReloadDelegate, UpdateCellProtocol {
    
    var posts = [Post]()
    var pageNum = 0
    
    var individualCellUpdate = false
    
    var getPostsController = GetPostsController()
    
    private func calculateIndexPathsToReload(from newPosts: [Post]) -> [IndexPath] {
        let startIndex = posts.count - newPosts.count
        let endIndex = startIndex + newPosts.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        self.refreshControl?.attributedTitle = NSAttributedString(string: "pull to refresh")
//        updateUI()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        findDuplicates()
        if position > scrollView.contentSize.height - 100 - scrollView.frame.size.height {
            
            guard !getPostsController.isPaginating else {
                return
                
            }
            print("fetch more data")
            print(getPostsController.isPaginating)
//            self.tableView.tableFooterView = createSpinnerFooter()
            self.tableView.tableFooterView = LoadingCell()
            
            Task {
                do {
//                    try await posts.append(contentsOf: GetPostsController().getPosts(userSecret: User.current!.secret, pageNumber: pageNum, pagination: true))
                    let response = try await getPostsController.getPosts(userSecret: User.current!.secret, pageNumber: pageNum, pagination: true)
                    guard !response.isEmpty else { return }
                    posts.append(contentsOf: response)
//                    navigationItem.title = "\(posts.count)"
                    pageNum += 1
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
//                        self.tableView.tableFooterView = nil
                    }
                } catch {
                    print(error)
//                    self.tableView.tableFooterView = nil
                }
            }
            
        }
    }
    
    func findDuplicates() {
        var duplicates = [Post]()
        for post in posts {
            var add = true
            for duplicate in duplicates {
                if duplicate.postid == post.postid {
                    add = false
                } else {
                    add = true
                }
            }
            if add {
                duplicates.append(post)
//                print("No duplicate found")
            } else {
                print("Duplicate Post found, postid: \(post.postid)")
            }
            
        }
    }
    
    
    func updateUI() {
        posts.removeAll()
        pageNum = 0
        getPosts(pageNumber: 0)
//        tableView.reloadData()
//        navigationItem.title = "\(posts.count)"
    }
    
    func updateCell(_ cell: UITableViewCell) {
        let indexPath = tableView.indexPath(for: cell) ?? IndexPath(row: 0, section: 1)
        posts.removeAll()
        for i in 0...pageNum {
            getPosts(pageNumber: i)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
        individualCellUpdate = false
    }
    
    @objc func refresh() {
        updateUI()
        self.refreshControl?.endRefreshing()
    }
    
    func getPosts(pageNumber: Int) {
//        getPostsController.isPaginating = true
        Task {
            do {
                // Make the API Call
//                print(User.current!.secret)
                let postsResponse = try await GetPostsController().getPosts(userSecret: User.current!.secret, pageNumber: pageNumber, pagination: true)
                
                print(postsResponse.count)
                posts.removeAll()
                self.posts.append(contentsOf: postsResponse)
//                navigationItem.title = "\(posts.count)"
                tableView.reloadData()
                pageNum += 1
                
            } catch {
                print(error)
//                errorLabel.text = "Invalid Username or Password"
            }
        }
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
                let indexPath: IndexPath = tableView.indexPath(for: cell)!
                posts[tableView.indexPath(for: cell)!.row] = response
                tableView.reloadRows(at: [indexPath], with: .none)
                
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func confirmationAlert(postid: Int) {
//        print("This Function was triggered")
//        print(postid)
        let confirmDeleteAlert = UIAlertController(title: "Confirmation", message: "Are you sure that you want to delete this post?", preferredStyle: .alert)
        
        confirmDeleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deletePost(postid: postid)
            print("Alert Delete Selected")
        }))
        confirmDeleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
//        confirmDeleteAlert.present(PostsTableViewController(), animated: true)
        
        self.present(confirmDeleteAlert, animated: true)
        
//        present(confirmDeleteAlert, animated: true)
    }
    
    func deletePost(postid: Int) {
//        print(self)
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
//        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return posts.count
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        
        let post = posts[indexPath.row]
        
        if post.postid == 136 {
            print(post)
        }
        
        cell.postAuthorUserNameLabel.text = "@\(post.authorUserName)"
        cell.postBodyLabel.text = post.body
        cell.postTitleLabel.text = post.title
        cell.postTitleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        cell.dateCreatedLabel.text = post.createdDate
        cell.commentsButton.titleLabel?.text = "\(post.numComments)"
        cell.likesButton.titleLabel?.text = "\(post.likes)"

        cell.delegate = self
        cell.reloadDelegate = self

//        print("Post")
//        print(post.authorUserId)
//        print("Cell:")
//        print(cell.userId)
        cell.userId = post.authorUserId
//        print("Cell:")
//        print(cell.postid)
//        print("Post:")
//        print(post.postid)
        cell.postid = post.postid
//        print("Updated Cell:")
//        print(cell.postid)
//        print("self is \(cell) and postID is \(post.postid) display at index \(indexPath)")

        cell.showTrashButton()
        cell.commentsNum.append(post.numComments)
        cell.likesNum.append(post.likes)

        if post.userLiked {
            cell.likesButton.tintColor = .red
            cell.likesButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            cell.likesButton.tintColor = .tintColor
            cell.likesButton.setImage(UIImage(systemName: "heart"), for: .normal)
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

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 55
        }
        
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "commentSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print(sender)
        switch segue.identifier {
        case "commentSegue":
            let commentsVC = segue.destination as! CommentsTableViewController
//            let commentsVC = nvc.viewControllers.first as! CommentsTableViewController
            
            commentsVC.postid = posts[tableView.indexPathForSelectedRow!.row].postid
            commentsVC.ogPoster = posts[tableView.indexPathForSelectedRow!.row].authorUserName
            
        case "createPostSegue":
            let commentsVC = segue.destination as! CreatePostTableViewController
            
            commentsVC.isComment = false
            commentsVC.delegate = self
            
        case "createCommentSegue":
            let button = sender as! UIButton
            let indexPathRow = button.tag
            
            let commentsVC = segue.destination as! CreatePostTableViewController
            
            commentsVC.postUsername = posts[indexPathRow].authorUserName
            commentsVC.isComment = true
            commentsVC.postid = posts[indexPathRow].postid
            commentsVC.delegate = self
            
        case "editPostSegue":
            let button = sender as! UIButton
            let indexPathRow = button.tag
            
            let editVC = segue.destination as! CreatePostTableViewController
            
//            editVC.post.removeFirst(1)
            editVC.post.append(posts[indexPathRow])
//            editVC.post = posts[indexPathRow]
            editVC.postid = posts[indexPathRow].postid
//            print(posts[indexPathRow].postid)
            editVC.isComment = false
            editVC.isEdit = true
            editVC.delegate = self
            
        default:
            print("What the hell did you do?")
        }
    }
    

}

public extension UITableView {
    
    func indexPathForView(_ view: UIView) -> IndexPath? {
        let center = view.center
        let viewCenter = self.convert(center, from: view.superview)
        let indexPath = self.indexPathForRow(at: viewCenter)
        return indexPath
    }
    
}
