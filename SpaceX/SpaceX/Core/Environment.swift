//
//  Environment.swift
//  SpaceX
//
//  Created by David Beleza on 23/10/2021.
//

import Foundation

public protocol Environment {
    var host: String { get }
}

struct EnvironmentImpl: Environment {
    static let shared = EnvironmentImpl()
    var host: String {
        guard let host = Bundle.main.infoDictionary?["Host"] as? String else { fatalError("Expected to have a host defined 💩") }
        return host
    }
}
