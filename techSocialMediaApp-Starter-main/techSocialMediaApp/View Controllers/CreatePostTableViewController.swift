//
//  CreatePostTableViewController.swift
//  techSocialMediaApp
//
//  Created by Boe Bogdin on 2/1/23.
//

import UIKit

protocol ReloadDelegate {
    func updateUI()
}

class CreatePostTableViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var isComment: Bool = false
    var isEdit: Bool = false
    var postid = 0
    var postUsername: String? = nil
    var post = [Post]()
    
    var delegate: ReloadDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if post.count > 1 {
            post.removeFirst()
        }
//        print(post[0].body)
//        print(postid)
//        print(post[0].postid)
        
        if isComment {
            navigationBar.topItem?.title = "Replying to @\(postUsername ?? "og Author"):"
            bodyTextField.text = "What do you want to say to @\(postUsername ?? "og Author")?"
        } else if isEdit {
            navigationBar.topItem?.title = "Edit Post"
            titleTextField.text = post[0].title
            bodyTextField.text = post[0].body
        } else {
            navigationBar.topItem?.title = "Create Post"
            bodyTextField.text = "What do you want to post?"
        }
        
        bodyTextField.textStorage.delegate = self
//        bodyTextField.rx.text.subscribe(onNext: { string in
//                print("rx: \(string)")
//        })
        
        bodyTextField.delegate = self
        titleTextField.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func createPost() {
        guard let postTitle = titleTextField.text, let body = bodyTextField.text else { return }
        
        Task {
            do {
                // Make the API Call
                let postsResponse = try await MakePostController().post(userSecret: User.current!.secret, title: postTitle, body: body)
                
//                posts.append(contentsOf: postsResponse)
//                print(posts.count)
//                print(posts[0].body)
                delegate?.updateUI()
                tableView.reloadData()
                
                
            } catch {
                print(error)
//                errorLabel.text = "Invalid Username or Password"
            }
        }
    }
    
    func editPost() {
        guard let postTitle = titleTextField.text, let body = bodyTextField.text else { return }
        
        Task {
            do {
                // Make the API Call
                print(User.current!.secret)
                let postsResponse = try await EditPostController().edit(userSecret: User.current!.secret, title: postTitle, body: body, postid: postid)
                
//                posts.append(contentsOf: postsResponse)
//                print(posts.count)
//                print(posts[0].body)
                delegate?.updateUI()
                tableView.reloadData()
                
                
            } catch {
                print(error)
//                errorLabel.text = "Invalid Username or Password"
            }
        }
    }
    
    func createComment() {
        guard let body = bodyTextField.text else { return }
        
        Task {
            do {
                // Make the API Call
                let postsResponse = try await MakeCommentController().reply(userSecret: User.current!.secret, body: body, postid: postid)
                
//                posts.append(contentsOf: postsResponse)
//                print(posts.count)
//                print(posts[0].body)
                tableView.reloadData()
                delegate?.updateUI()
                CommentsTableViewController().tableView.reloadData()
                
            } catch {
                print(error)
//                errorLabel.text = "Invalid Username or Password"
            }
        }
    }
    
    
    
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if isComment {
            return 1
        } else {
            return 2
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isComment {
            return "Reply"
        } else {
            if section == 0 {
                return "Title"
            } else {
                return "Body"
            }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        
        // Configure the cell...
        
        if isComment {
            return super.tableView(tableView, cellForRowAt: IndexPath(row: indexPath.row, section: 1))
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if isComment {
                return 400
            } else {
                return 75
            }
        } else {
            return 400
        }
        
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if isComment {
                return 400
            } else {
                return 75
            }
        } else {
            return 400
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func postButtonPressed(_ sender: Any) {
        if isComment {
            createComment()
        } else if isEdit {
            editPost()
        } else {
            createPost()
        }
        self.dismiss(animated: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !isEdit {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            if isComment {
                textView.text = "What do you want to say to @\(postUsername ?? "og Author")?"
            } else {
                textView.text = "What do you want to post?"
            }
            
            textView.textColor = .lightGray
        }
    }
    
    
}

extension CreatePostTableViewController: NSTextStorageDelegate {
        func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
                print("string: \(textStorage.string)")
        }
}
