//
//  DeletePostController.swift
//  techSocialMediaApp
//
//  Created by Boe Bogdin on 2/2/23.
//

import Foundation

class DeletePostController {
    enum DeleteError: Error, LocalizedError {
        case couldNotDeletePost
    }
    
    
    func deletePost(userSecret: UUID, postid: Int) async throws -> Bool {
        // Initialize our session and request
        let session = URLSession.shared
        var urlComponents = URLComponents(string: "\(API.url)/post")!
//        var request = URLRequest(url: URL(string: "\(API.url)/post")!)
//        print(request.url?.absoluteString)
//        print("PostID: \(postid)")
        
        // Put the credentials in JSON format
        urlComponents.queryItems = [
            URLQueryItem(name: "userSecret", value: "\(userSecret)"),
            URLQueryItem(name: "postid", value: "\(postid)")
        ]
//        let credentials: [String: Any] = ["userSecret": "\(userSecret)", "postid": "\(postid)"]
        
        var request = URLRequest(url: urlComponents.url!)
        
        // Add json data to the body of the request. Also clarify that this is a POST request
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        print(request.url)
        // Make the request
        let (data, response) = try await session.data(for: request)
        
        // Ensure we had a good response (status 200)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let response = response as? HTTPURLResponse
            print(response?.statusCode)
            throw DeleteError.couldNotDeletePost
        }
        
        // Decode our response data to a usable User struct
        let decoder = JSONDecoder()
        let somethingIHaveNoIdeaWhat = try decoder.decode(Post.self, from: data)
        
        
        return true
    }
}
