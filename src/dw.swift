import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLSession {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let data = data, let response = response {
                    continuation.resume(returning: (data, response))
                } else {
                    continuation.resume(throwing: URLError(.unknown))
                }
            }
            task.resume()
        }
    }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

public class Dw {
    private let api = "https://www.dw.com/graph-api"
    private var headers: [String: String]
    
    public init() {
        self.headers = [
        "Accept":"*/*",
        "Connection":"keep-alive",
        "Accept-Encoding":"deflate, zstd",
        "Accept-Language":"en-US,en;q=0.9",
        "Host":"www.dw.com",
        "User-Agent":"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36"
        ]

    }
    
    private func fetchJSON(from urlString: String,method: HTTPMethod = .get,body: Data? = nil,queryParameters: [String: String]? = nil) async throws -> Any {
        var urlComponents = URLComponents(string: urlString)
        if let queryParameters = queryParameters {
            urlComponents?.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        guard let url = urlComponents?.url else {
            throw NSError(domain: "Invalid URL", code: -1)
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    public func getBreakingNews(lang: String="ru") async throws -> Any {
        return try await fetchJSON(from: "\(api)/\(lang)/breaking-news")
    }
    
    public func getContentArticle(lang: String="ru",type: String="article",contentId: Int) async throws -> Any {
        return try await fetchJSON(from: "\(api)/\(lang)/content/\(type)/\(contentId)")
    }
    
    public func topStoryZoneList(lang: String="ru") async throws -> Any {
        return try await fetchJSON(from: "\(api)/\(lang)/top-story-zone")
    }
    
    public func topStoryZone(lang: String="ru",storyId: Int) async throws -> Any {
        return try await fetchJSON(from: "\(api)/\(lang)/top-story-zone/\(storyId)")
    }
    
    public func getLivestream(lang: String="ru",fullLang: String="russian") async throws -> Any {
        return try await fetchJSON(from: "\(api)/\(lang)/livestream/\(fullLang)")
    }
}
