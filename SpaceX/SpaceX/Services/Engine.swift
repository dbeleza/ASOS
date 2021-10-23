//
//  Engine.swift
//  SpaceX
//
//  Created by David Beleza on 22/10/2021.
//

import Foundation

final class Engine {
    let networkService: NetworkService = NetworkServiceImpl(environment: EnvironmentImpl.shared, session: URLSession.shared)
    let reachabilityService: ReachabilityService = ReachabilityImpl()
    lazy var launchService: LaunchService = LaunchServiceImpl(engine: self)
    lazy var companyService: CompanyService = CompanyServiceImpl(engine: self)
}

extension Engine: HasNetworkService {}
extension Engine: HasReachabilityService {}
extension Engine: HasLaunchService {}
extension Engine: HasCompanyService {}
