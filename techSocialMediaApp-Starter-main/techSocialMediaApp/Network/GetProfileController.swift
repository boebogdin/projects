//
//  GetProfileController.swift
//  techSocialMediaApp
//
//  Created by Boe Bogdin on 2/1/23.
//

import Foundation

class GetProfileController {
    enum ProfileError: Error, LocalizedError {
        case couldNotFetchProfile
    }
    
    
    func getProfile(userUUID: UUID, userSecret: UUID) async throws -> UserProfile {
        
        // Initialize our session and urlComponents
        let session = URLSession.shared
        var urlComponents = URLComponents(string: "\(API.url)/userProfile")!
        
        // Add the query items
        
        urlComponents.queryItems = [
            URLQueryItem(name: "userUUID", value: "\(userUUID)"),
            URLQueryItem(name: "userSecret", value: "\(userSecret)")
        ]
        
        var request = URLRequest(url: urlComponents.url!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Make the request
        let (data, response) = try await session.data(for: request)
//        print(data)
        
        // Ensure we had a good response (status 200)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let resp = response as? HTTPURLResponse
            print("Error Code: \(resp?.statusCode ?? 1000)")
            throw ProfileError.couldNotFetchProfile
        }
        
        // Decode our response data to a usable User struct
        let decoder = JSONDecoder()
        let profile = try decoder.decode(UserProfile.self, from: data)

        return profile
    }
}
