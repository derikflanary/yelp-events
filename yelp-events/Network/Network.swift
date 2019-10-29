//
//  Network.swift
//  network-combine
//
//  Created by Derik Flanary on 10/15/19.
//  Copyright © 2019 Derik Flanary. All rights reserved.
//

import Foundation
import Combine

class Network {
    
    private struct Keys {
        static let acceptHeader = "Accept"
        static let applicationJSON = "application/json"
        static let authorization = "Authorization"
        static let bearer = "Bearer"
        static let contentTypeHeader = "Content-Type"
        static let requestIdHeader = "X-Request-Id"
    }
    
    var environment: ProtectedAPIEnvironment?
    
    private var defaultSession: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10.0
        guard let environment = environment, let token = environment.bearerToken, !environment.isExpired else { return URLSession(configuration: configuration) }
        configuration.httpAdditionalHeaders = [Keys.authorization: "\(Keys.bearer) \(token)"]
        return URLSession(configuration: configuration)
    }
    
    init(environment: ProtectedAPIEnvironment) {
        self.environment = environment
    }
    
    
    /// Returns a Publisher with an optional value for the response type.
    /// Returns nil if there is an error
    func requestOptional<T: Codable>(_ urlRequest: URLRequest, responseAs: T.Type) -> AnyPublisher<T?, Never> {
        let request = adapt(urlRequest)
        
        return defaultSession.dataTaskPublisher(for: request)
            .retry(3)
            .map { $0.data }
            .decode(type: T?.self, decoder: JSONDecoder())
            .replaceError(with: nil)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    /// Returns a Publisher with the Type or an APIError
    func request<T: Codable>(_ urlRequest: URLRequest, responseAs: T.Type) -> AnyPublisher<T, Error> {
        let request = adapt(urlRequest)
                
        return defaultSession.dataTaskPublisher(for: request)
            .retry(3)
            .mapError{ error -> APIError in
                return APIError.networkError(error)
            }
            .tryMap { output in
                if let error = self.error(for: output.response, data: output.data) {
                    throw error
                }
                return output.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
                    

    
    private func error(for response: URLResponse?, data: Data) -> APIError? {
        guard let response = response as? HTTPURLResponse else {
            return APIError.networkError(nil)
        }
        switch response.statusCode {
        case 400, 422:
            let detail = String(data: data, encoding: .utf8)
            return APIError.validationFailed(detail)
        case 200..<299:
            return nil
        default:
            return APIError.unsuccessfulRequest(response.curlOutput(with: data))
        }
    }

}


// Adapter

private extension Network {
    
    
    private func adapt(_ urlRequest: URLRequest) -> URLRequest {
        var request = urlRequest
        request.url = request.url?.based(at: environment?.baseURL)
        if let method = request.httpMethod, method == HTTPMethod.post.rawValue.uppercased(), request.value(forHTTPHeaderField: Keys.contentTypeHeader) == nil {
            request.setValue(Keys.applicationJSON, forHTTPHeaderField: Keys.contentTypeHeader)
        }
        request.addValue(UUID().uuidString, forHTTPHeaderField: Keys.requestIdHeader)
        
        return request
    }
    
}


extension URL {
    
    func based(at base: URL?) -> URL? {
        guard let base = base else { return self }
        guard let baseComponents = URLComponents(string: base.absoluteString) else { return self }
        guard var components = URLComponents(string: self.absoluteString) else { return self }
        guard components.scheme == nil else { return self }

        components.scheme = baseComponents.scheme
        components.host = baseComponents.host
        components.port = baseComponents.port
        components.path = baseComponents.path + components.path
        return components.url
    }
    
}
