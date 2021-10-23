//
//  NetworkService.swift
//  SpaceX
//
//  Created by David Beleza on 22/10/2021.
//

import Foundation

public protocol NetworkService: AnyObject {
    typealias Response = (data: Data?, urlResponse: URLResponse?, error: Error?)
    func execute(request: Request, completion: @escaping (Response) -> Void)
}

final class NetworkServiceImpl: NetworkService {
    enum NetworkError: Error {
        case failedBuildRequest
    }
    private let session: URLSession
    private let environment: Environment

    init(environment: Environment, session: URLSession) {
        self.session = session
        self.environment = environment
    }

    func execute(request: Request, completion: @escaping (Response) -> Void) {
        do {
            let request = try buildUrlRequest(from: request)
            session.dataTask(with: request) { data, response, error in
                completion((data, response, error))
            }.resume()
        } catch {
            completion((data: nil, urlResponse: nil, error: NetworkError.failedBuildRequest))
        }
    }

    func buildUrlRequest(from request: Request) throws -> URLRequest {
        guard let baseUrl = URL(string: environment.host) else { throw NetworkError.failedBuildRequest }

        let fullUrl = baseUrl.appendingPathComponent(request.path)
        var urlRequest = URLRequest(url: fullUrl)

        // Set the HTTP method
        urlRequest.httpMethod = request.method.rawValue

        // Set the headers
        request.headers?.forEach { urlRequest.addValue($0.value.rawValue, forHTTPHeaderField: $0.key.rawValue) }

        // Set the parameters
        switch request.parameters {
        case .body(let data):
            if let data = data {
                urlRequest.httpBody = data
            }

        case .url(let params):
            if let params = params {
                let queryParams: [URLQueryItem] = params.map { URLQueryItem(name: $0.key, value: $0.value) }

                guard var components = URLComponents(string: fullUrl.absoluteString) else { throw NetworkError.failedBuildRequest }

                components.queryItems = queryParams
                urlRequest.url = components.url
            }
        case .none:
            break
        }

        return urlRequest
    }
}
