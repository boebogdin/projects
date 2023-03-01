//
//  CommentsTableViewController.swift
//  techSocialMediaApp
//
//  Created by Boe Bogdin on 2/1/23.
//

import UIKit

class CommentsTableViewController: UITableViewController {
    
    var comments = [Comment]()
    var postid: Int = 0
    var ogPoster: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getComments()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func getComments() {
        Task {
            do {
                // Make the API Call
//                print(User.current!.secret)
                let commentsResponse = try await GetCommentsController().getComments(userSecret: User.current!.secret, postid: postid, pageNumber: 0)
                
                comments.append(contentsOf: commentsResponse)
//                print(comments.count)
                tableView.reloadData()
                
                
            } catch {
                print(error)
//                errorLabel.text = "Invalid Username or Password"
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comments.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentsCell", for: indexPath) as! CommentTableViewCell

        // Configure the cell...
        let comment = comments[indexPath.row]
        cell.dateCreatedLabel.text = comment.createdDate
        cell.commentBodyLabel.text = comment.body
        cell.commenterUserNameLabel.text = comment.userName
        cell.replyingToLabel.text = "Replying to \(ogPoster):"

        return cell
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

    @IBAction func doneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
