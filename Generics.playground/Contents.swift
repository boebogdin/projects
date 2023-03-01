import UIKit
import Foundation

protocol APIRequest {
    
    associatedtype Response
    
    var urlRequest: URLRequest { get }
    func decodeResponse(data: Data) throws -> Response
}

enum APIRequestError: Error {
    case itemNotFound
}

func sendRequest<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
    
    let requestData = try await URLSession.shared.data(for: request.urlRequest)
    
    guard let httpResponse = requestData.1 as? HTTPURLResponse, httpResponse.statusCode == 200 else {
        throw APIRequestError.itemNotFound
    }
    
    let decoded = try request.decodeResponse(data: requestData.0)
    return decoded
    
}



func containsOrNot<T: Equatable>(_ arr:[T], x:T) -> Bool {

    return arr.filter({$0 == x}).isEmpty ? false : true

}

containsOrNot(["hello", "one", "three"], x: "orne")



