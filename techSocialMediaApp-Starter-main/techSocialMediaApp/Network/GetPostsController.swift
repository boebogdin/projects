//
//  GetPostsController.swift
//  techSocialMediaApp
//
//  Created by Boe Bogdin on 2/1/23.
//

import Foundation

class GetPostsController {
    enum PostError: Error, LocalizedError {
        case couldNotFetchPosts
    }
    
    var isPaginating: Bool = false
    
    
    func getPosts(userSecret: UUID, pageNumber: Int?, pagination: Bool) async throws -> [Post] {
        
        if pagination {
            isPaginating = true
        }
        
        let pageNumber: Int = pageNumber ?? 0
        
        // Initialize our session and urlComponents
        let session = URLSession.shared
        var urlComponents = URLComponents(string: "\(API.url)/posts")!
        
        // Add the query items
        
        urlComponents.queryItems = [
            URLQueryItem(name: "userSecret", value: "\(userSecret)"),
            URLQueryItem(name: "pageNumber", value: "\(pageNumber)")
        ]
        
        var request = URLRequest(url: urlComponents.url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Make the request
        let (data, response) = try await session.data(for: request)
//        print(data)
        
        // Ensure we had a good response (status 200)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let resp = response as? HTTPURLResponse
            print(resp?.statusCode ?? 1000)
            throw PostError.couldNotFetchPosts
        }
        
        // Decode our response data to a usable User struct
        let decoder = JSONDecoder()
        let posts = try decoder.decode([Post].self, from: data)
        
        if pagination {
            isPaginating = false
        } else {
            isPaginating = false
        }
        
        return posts
    }
}
