//
//  SpaceXRequest.swift
//  SpaceX
//
//  Created by David Beleza on 23/10/2021.
//

import Foundation

enum SpaceXRequest {
    case companyDetails
    case launchList(queryData: Data)
}

extension SpaceXRequest: Request {
    var path: String {
        switch self {
        case .companyDetails:
            return "/v4/company"
        case .launchList:
            return "/v4/launches/query"
        }
    }

    var method: RequestMethod {
        switch self {
        case .companyDetails:
            return .get
        case .launchList:
            return .post
        }
    }

    var parameters: RequestParams? {
        switch self {
        case .launchList(queryData: let data):
            return .body(data)
        case .companyDetails:
            return nil
        }
    }

    var headers: [HeaderKey : HeaderValue]? {
        switch self {
        case .launchList:
            return [.contentType: .json]
        case .companyDetails:
            return nil
        }
    }
}
