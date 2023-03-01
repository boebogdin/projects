//
//  MakePostController.swift
//  techSocialMediaApp
//
//  Created by Boe Bogdin on 2/1/23.
//

import Foundation

class MakePostController {
    enum PostError: Error, LocalizedError {
        case couldNotPost
    }
    
    
    func post(userSecret: UUID, title: String, body: String) async throws -> Bool {
        // Initialize our session and request
        let session = URLSession.shared
        var request = URLRequest(url: URL(string: "\(API.url)/createPost")!)
        
        // Put the credentials in JSON format
        let post = ["title": title, "body": body]
        let credentials: [String: Any] = ["userSecret": "\(userSecret)", "post": post]
        
        // Add json data to the body of the request. Also clarify that this is a POST request
        request.httpBody = try JSONSerialization.data(withJSONObject: credentials, options: .prettyPrinted)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        print(request.url)
        // Make the request
        let (data, response) = try await session.data(for: request)
        
        // Ensure we had a good response (status 200)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw PostError.couldNotPost
        }
        
        // Decode our response data to a usable User struct
        let decoder = JSONDecoder()
        let user = try decoder.decode(Post.self, from: data)
                
        return true
    }
}
