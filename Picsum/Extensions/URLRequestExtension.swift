import Foundation

extension URLRequest {
    
    // MARK: Internal functions
    
    static func makeHTTPRequest(
        base: URL = baseURL,
        path: String,
        method: HTTPMethod = .get
    ) -> URLRequest {
        guard let url = URL(string: path, relativeTo: base) else {
            preconditionFailure("Failed to init URL with path \(path) relative to base \(base)")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}

// MARK: - HTTPMethod

enum HTTPMethod: String {
    case get = "GET"
}

// MARK: - Constants

let baseURL: URL = {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "picsum.photos"
    return components.url!
}()
