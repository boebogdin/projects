//
//  Profile.swift
//  techSocialMediaApp
//
//  Created by Boe Bogdin on 2/1/23.
//

import Foundation

struct UserProfile: Decodable, Encodable {
    var firstName: String
    var lastName: String
    var userName: String
    var userUUID: UUID
    var bio: String?
    var techInterests: String?
    var posts: [Post]
}
