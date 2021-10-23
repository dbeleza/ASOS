//
//  CompanyServiceStub.swift
//  SpaceXTests
//
//  Created by David Beleza on 23/10/2021.
//

import Foundation
import SpaceX

final class CompanyServiceStub: CompanyService {

    var companyResponse = Company.Response(name: "spacex",
                                           founder: "spacex",
                                           founded: 1234,
                                           employees: 12,
                                           launchSites: 12,
                                           valuation: 12345)

    var response: (Result<Company.Response, Error>)?

    func fetchCompany(completion: @escaping (Result<Company.Response, Error>) -> Void) {
        completion(response!)
    }
}
