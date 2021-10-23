//
//  EngineMock.swift
//  SpaceXTests
//
//  Created by David Beleza on 23/10/2021.
//

import Foundation
import SpaceX

final class EngineMock {
    var networkService: NetworkService = NetworkServiceStub()
    var reachabilityService: ReachabilityService = ReachabilityServiceStub()
    var launchService: LaunchService = LaunchServiceStub()
    var companyService: CompanyService = CompanyServiceStub()
}

extension EngineMock: HasNetworkService {}
extension EngineMock: HasReachabilityService {}
extension EngineMock: HasLaunchService {}
extension EngineMock: HasCompanyService {}
