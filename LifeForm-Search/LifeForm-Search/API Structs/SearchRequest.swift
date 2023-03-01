//
//  SearchApi.swift
//  LifeForm-Search
//
//  Created by Boe Bogdin on 1/20/23.
//

import Foundation

// The Search request object that returns the inital animal object

struct SearchRequest: APIRequest {
    var search: String
    
    var urlRequest: URLRequest {
        
        
        let url = URL(string: "https://eol.org/api/search/1.0.json")
        var components = URLComponents(url: url!, resolvingAgainstBaseURL: true)!
        
        components.queryItems = [URLQueryItem(name: "q", value: search), URLQueryItem(name: "page", value: "1")]
        
        
        return URLRequest(url: components.url!)
    }
    
    func decodeResponse(data: Data) throws -> Animals {
        //  print(data.prettyPrintedJsonString())
        
        if let animals = try? JSONDecoder().decode(Animals.self, from: data) {
            
            
            return animals
        } else {
            print("could not decode animal data")
            throw APIRequestError.animalNotDecoded
        }
        
    }
}

