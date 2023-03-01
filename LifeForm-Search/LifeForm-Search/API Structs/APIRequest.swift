//
//  APIRequest.swift
//  LifeForm-Search
//
//  Created by Boe Bogdin on 1/20/23.
//

import Foundation

protocol APIRequest {
    
    associatedtype Response
    
    var urlRequest: URLRequest { get }
    func decodeResponse(data: Data) throws -> Response
}

enum APIRequestError: Error {
    case animalNotDecoded
    case pageNotDecoded
}

func sendRequest<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
    
    let requestData = try await URLSession.shared.data(for: request.urlRequest)
    
    guard let httpResponse = requestData.1 as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        print("Couldn't find data")
        throw APIRequestError.animalNotDecoded
    }
    
    let decoded = try request.decodeResponse(data: requestData.0)
    
    return decoded
    
}
