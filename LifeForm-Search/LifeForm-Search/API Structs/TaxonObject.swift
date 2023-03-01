//
//  PageObject.swift
//  LifeForm-Search
//
//  Created by Boe Bogdin on 1/22/23.
//

import Foundation

struct TaxonObject: Codable {
    var identifier: Int

    var scientificName: String
    
    var dataObjects: [DataObject]
}


struct BaseObject: Codable {
    var taxonConcept: TaxonObject
    
}

struct DataObject: Codable {
    var mediaURL: String
    var license: String
}
