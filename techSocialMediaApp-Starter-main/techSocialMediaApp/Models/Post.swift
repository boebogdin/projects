//
//  Post.swift
//  techSocialMediaApp
//
//  Created by Boe Bogdin on 2/1/23.
//

import Foundation

struct Post: Codable {
    var postid: Int
    var title: String
    var body: String
    var authorUserName: String
    var authorUserId: UUID
    var likes: Int
    var userLiked: Bool
    var numComments: Int
    var createdDate: String
}
