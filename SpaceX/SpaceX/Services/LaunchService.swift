//
//  LaunchService.swift
//  SpaceX
//
//  Created by David Beleza on 22/10/2021.
//

import Foundation

enum LaunchServiceError: Error {
    case error
    case invalidData
}

public protocol LaunchService {
    func fetchLaunches(limit: Int, offset: Int, filter: Filter.State?, completion: @escaping ((Result<Launch.ListResponse, Error>)) -> Void)
}

final class LaunchServiceImpl: LaunchService {
    typealias Engine = HasNetworkService
    private weak var engine: Engine?
    private let jsonEncoder = JSONEncoder()

    init(engine: Engine) {
        self.engine = engine
    }

    func fetchLaunches(limit: Int, offset: Int, filter: Filter.State?, completion: @escaping ((Result<Launch.ListResponse, Error>)) -> Void) {
        guard let engine = engine else { return }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            let data = self.retrieveFetchLaunchesQueryData(limit: limit, offset: offset, filter: filter)
            let request = SpaceXRequest.launchList(queryData: data)

            engine.networkService.execute(request: request) { response in
                guard let data = response.data, response.error == nil else {
                    completion(.failure(LaunchServiceError.error))
                    return
                }

                do {
                    let launches = try JSONDecoder().decode(Launch.ListResponse.self, from: data)
                    completion(.success(launches))
                } catch {
                    completion(.failure(LaunchServiceError.invalidData))
                }
            }
        }
    }

    func retrieveFetchLaunchesQueryData(limit: Int, offset: Int, filter: Filter.State?) -> Data {
        let requestBuilder = Launch.Request.Builder()

        if let filter = filter {
            requestBuilder
                .setLaunchDateSort(isAscending: filter.isAscending)
                .setSuccess(success: filter.isSuccess)
                .setYear(year: filter.selectedYear)
        }

        let query = requestBuilder
            .setLimit(limit: limit)
            .setOffset(offset: offset)
            .build()

        guard let data = try? jsonEncoder.encode(query) else {
            fatalError("Could not encode query to Json")
        }

        return data
    }
}
