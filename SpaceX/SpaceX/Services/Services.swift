//
//  Services.swift
//  SpaceX
//
//  Created by David Beleza on 22/10/2021.
//

import Foundation

public protocol HasNetworkService: AnyObject {
    var networkService: NetworkService { get }
}

public protocol HasCompanyService: AnyObject {
    var companyService: CompanyService { get }
}

public protocol HasReachabilityService: AnyObject {
    var reachabilityService: ReachabilityService { get }
}
