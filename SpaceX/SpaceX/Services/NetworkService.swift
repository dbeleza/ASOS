//
//  NetworkService.swift
//  SpaceX
//
//  Created by David Beleza on 22/10/2021.
//

import Foundation

public protocol NetworkService: AnyObject {
    typealias Response = (data: Data?, urlResponse: URLResponse?, error: Error?)
    func get(scheme: String, host: String, path: String, queryItems: [URLQueryItem]?) -> URLRequest
    func post(scheme: String, host: String, path: String, body: Data) -> URLRequest
    func request(urlRequest: URLRequest, completion: @escaping (Response) -> Void)
}

final class NetworkServiceImpl: NetworkService {
    let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    func get(scheme: String, host: String, path: String, queryItems: [URLQueryItem]?) -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = queryItems

        guard let url = components.url else { fatalError("URL not well constructed 💩") }

        return URLRequest(url: url)
    }

    func post(scheme: String, host: String, path: String, body: Data) -> URLRequest {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path

        guard let url = components.url else { fatalError("URL not well constructed 💩") }

        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = body

        return request
    }

    func request(urlRequest: URLRequest, completion: @escaping (Response) -> Void) {
        session.dataTask(with: urlRequest) { data, response, error in
            completion((data, response, error))
        }.resume()
    }
}
