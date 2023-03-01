//
//  EditProfileController.swift
//  techSocialMediaApp
//
//  Created by Boe Bogdin on 2/16/23.
//

import Foundation

class EditProfileController {
    enum EditError: Error, LocalizedError {
        case couldNotEdit
    }
    
    
    func editProfile(userSecret: UUID, username: String, bio: String, techInterests: String) async throws -> [String:Bool] {
        // Initialize our session and request
        let session = URLSession.shared
        var request = URLRequest(url: URL(string: "\(API.url)/updateProfile")!)
        
        // Put the credentials in JSON format
        let profile = ["userName": "\(username)", "bio": bio, "techInterests": techInterests]
        let credentials: [String: Any] = ["userSecret": "\(userSecret)", "profile": profile]
//        print("Edit Testing: \(body)")
        // Add json data to the body of the request. Also clarify that this is a POST request
        request.httpBody = try JSONSerialization.data(withJSONObject: credentials, options: .prettyPrinted)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        print(request.url)
        // Make the request
        let (data, response) = try await session.data(for: request)
        
        // Ensure we had a good response (status 200)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            let response = response as? HTTPURLResponse
            print(response)
            throw EditError.couldNotEdit
        }
        
        // Decode our response data to a usable User struct
        let decoder = JSONDecoder()
        let message = try decoder.decode([String:Bool].self, from: data)
//        print(message)
        return message
    }
}
