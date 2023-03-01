//
//  DetailReuest.swift
//  LifeForm-Search
//
//  Created by Boe Bogdin on 1/22/23.
//

import Foundation

struct TaxonRequest: APIRequest {
    var animalID: String

    var urlRequest: URLRequest {
        var stringURL = "https://eol.org/api/pages/1.0/"
        
        let id = animalID
        
        stringURL += id
        
        stringURL += ".json"
        
        let url = URL(string: stringURL)
        
        var components = URLComponents(url: url!, resolvingAgainstBaseURL: true)!
        
        let queryItems = ["taxonomy": "true", "images_per_page" : "1", "language": "en"]
        
        components.queryItems = queryItems.map { URLQueryItem(name: $0, value: $1) }
    
    
        return URLRequest(url: components.url!)
    }
    
    
    func decodeResponse(data: Data) throws -> BaseObject {
        //print(data.prettyPrintedJsonString())
        
        if let page = try? JSONDecoder().decode(BaseObject.self, from: data) {
            return page
        } else {

           // print("Could not decode page data")
            throw APIRequestError.pageNotDecoded
        }
    }

    
    


}


