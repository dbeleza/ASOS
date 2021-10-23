//
//  ReachabilityServiceStub.swift
//  SpaceXTests
//
//  Created by David Beleza on 23/10/2021.
//

import Foundation
import SpaceX

final class ReachabilityServiceStub: ReachabilityService {
    var isReachable: Bool = true

    func start(_ isReachable: ((Bool) -> Void)?) {
        isReachable?(self.isReachable)
    }

    func stop() {}
}
