//
//  SearchObject.swift
//  LifeForm-Search
//
//  Created by Boe Bogdin on 1/22/23.
//

import Foundation

struct Animal: Codable {
    
    var id : Int
    
    var scientificName : String
    
    var commonName : String
    
    var link: String
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case scientificName = "title"
        case commonName = "content"
        case link
    }
}

struct Animals: Codable {
    var results: [Animal]
}
