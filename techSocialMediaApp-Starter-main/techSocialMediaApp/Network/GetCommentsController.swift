//
//  GetCommentsController.swift
//  techSocialMediaApp
//
//  Created by Boe Bogdin on 2/1/23.
//

import Foundation

class GetCommentsController {
    enum CommentError: Error, LocalizedError {
        case couldNotFetchComments
    }
    
    
    func getComments(userSecret: UUID, postid: Int, pageNumber: Int?) async throws -> [Comment] {
        let pageNumber: Int = pageNumber ?? 0
        
        // Initialize our session and urlComponents
        let session = URLSession.shared
        var urlComponents = URLComponents(string: "\(API.url)/comments")!
        
        // Add the query items
        
        urlComponents.queryItems = [
            URLQueryItem(name: "userSecret", value: "\(userSecret)"),
            URLQueryItem(name: "postid", value: "\(postid)"),
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
            throw CommentError.couldNotFetchComments
        }
        
        // Decode our response data to a usable User struct
        let decoder = JSONDecoder()
        let comments = try decoder.decode([Comment].self, from: data)
                
        return comments
    }
}
