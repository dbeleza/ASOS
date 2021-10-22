//
//  ReachabilityService.swift
//  SpaceX
//
//  Created by David Beleza on 22/10/2021.
//

import Foundation
import Network

public protocol ReachabilityService {
    var isReachable: Bool { get }
    func start(_ isReachable: ( (Bool) -> Void)?)
    func stop()
}

class ReachabilityImpl: ReachabilityService {
    private static let labelQueue = "MonitorNetwork"

    var isReachable: Bool {
        return _isReachable
    }

    // NWPathMonitor doens't work well on simulators 🤷‍♂️
    let monitor = NWPathMonitor()
    private var _isReachable: Bool = false


    func start(_ isReachable: ((Bool) -> Void)? = nil) {
        monitor.pathUpdateHandler = { [weak self] path in
            isReachable?(path.status == .satisfied)
            self?._isReachable = path.status == .satisfied
        }

        let queue = DispatchQueue(label: Self.labelQueue)
        monitor.start(queue: queue)
    }

    func stop() {
        monitor.cancel()
    }
}
