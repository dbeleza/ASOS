//
//  Constants.swift
//  SpaceX
//
//  Created by David Beleza on 22/10/2021.
//

import Foundation
import UIKit

struct Constants {
    struct API {
        static let scheme = "https"
        static var host: String {
            guard let host = Bundle.main.infoDictionary?["Host"] as? String else { fatalError("Expected to have a host defined 💩") }
            return host
        }
        static let postHttpMethod = "POST"
        static let jsonContentType = "application/json"
        static let contentTypeHeader = "Content-Type"
    }

    struct Margin {
        static let baseline: CGFloat = 8.0
    }

    struct Animation {
        static let short = 0.3
    }
}
