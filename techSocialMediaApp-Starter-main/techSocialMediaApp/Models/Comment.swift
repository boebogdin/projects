//
//  Comment.swift
//  techSocialMediaApp
//
//  Created by Boe Bogdin on 2/1/23.
//

import Foundation

struct Comment: Codable {
    var commentId: Int
    var body: String
    var userName: String
    var userId: UUID
    var createdDate: String
}
