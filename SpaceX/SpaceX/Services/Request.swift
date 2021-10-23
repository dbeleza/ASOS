//
//  Request.swift
//  SpaceX
//
//  Created by David Beleza on 23/10/2021.
//

import Foundation

public enum RequestMethod: String {
    case post = "POST"
    case put = "PUT"
    case get = "GET"
}

public enum HeaderValue: String {
    case json = "application/json"
}

public enum HeaderKey: String {
    case contentType = "Content-Type"
}

public enum RequestParams {
    case body(Data?)
    case url([String: String]?)
}

public protocol Request {
    var path: String { get }
    var method: RequestMethod { get }
    var parameters: RequestParams? { get }
    var headers: [HeaderKey: HeaderValue]? { get }
}
