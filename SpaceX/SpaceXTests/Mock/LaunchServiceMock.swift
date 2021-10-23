//
//  LaunchServiceMock.swift
//  SpaceXTests
//
//  Created by David Beleza on 23/10/2021.
//

import Foundation
@testable import SpaceX

final class LaunchServiceMock: LaunchService {
    enum Event: Equatable {
        case fetchLaunch
    }

    var log: [Event] = []

    func fetchLaunches(limit: Int, offset: Int, filter: Filter.State?, completion: @escaping ((Result<Launch.ListResponse, Error>)) -> Void) {
        log.append(.fetchLaunch)
    }
}
