//
//  CompanyService.swift
//  SpaceX
//
//  Created by David Beleza on 22/10/2021.
//

import Foundation

enum CompanyServiceError: Error {
    case error
    case invalidData
}

public protocol CompanyService {
    func fetchCompany(completion: @escaping (Result<Company.Response, Error>) -> Void)
}

final class CompanyServiceImpl: CompanyService {
    typealias Engine = HasNetworkService & HasReachabilityService
    private weak var engine: Engine?

    init(engine: Engine) {
        self.engine = engine
    }

    func fetchCompany(completion: @escaping (Result<Company.Response, Error>) -> Void) {
        guard let engine = engine else { return }

        engine.networkService.execute(request: SpaceXRequest.companyDetails) { response in
            guard let data = response.data, response.error == nil else {
                completion(.failure(CompanyServiceError.error))
                return
            }

            do {
                let company = try JSONDecoder().decode(Company.Response.self, from: data)
                completion(.success(company))
            } catch {
                completion(.failure(CompanyServiceError.invalidData))
            }
        }
    }
}
