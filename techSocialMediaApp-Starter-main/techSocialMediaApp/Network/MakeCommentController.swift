//
//  MakeCommentController.swift
//  techSocialMediaApp
//
//  Created by Boe Bogdin on 2/1/23.
//

import Foundation

class MakeCommentController {
    enum CommentError: Error, LocalizedError {
        case couldNotComment
    }
    
    
    func reply(userSecret: UUID, body: String, postid: Int) async throws -> Bool {
        // Initialize our session and request
        let session = URLSession.shared
        var request = URLRequest(url: URL(string: "\(API.url)/createComment")!)
        
        // Put the credentials in JSON format
        let credentials: [String: Any] = ["userSecret": "\(userSecret)", "commentBody": body, "postid": postid]
        
        // Add json data to the body of the request. Also clarify that this is a POST request
        request.httpBody = try JSONSerialization.data(withJSONObject: credentials, options: .prettyPrinted)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        print(request.url)
        // Make the request
        let (data, response) = try await session.data(for: request)
        
        // Ensure we had a good response (status 200)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw CommentError.couldNotComment
        }
        
        // Decode our response data to a usable User struct
        let decoder = JSONDecoder()
        let user = try decoder.decode(Post.self, from: data)
                
        return true
    }
}
