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

    init(engine: Engine) {
        self.engine = engine
    }

    func fetchLaunches(limit: Int, offset: Int, filter: Filter.State?, completion: @escaping ((Result<Launch.ListResponse, Error>)) -> Void) {
        guard let engine = engine else { return }

        let data = retrieveFetchLaunchesQueryData(limit: limit, offset: offset, filter: filter)
        let request = engine.networkService.post(scheme: Constants.API.scheme, host: Constants.API.host, path: "/v4/launches/query", body: data)

        engine.networkService.request(urlRequest: request) { response in
            guard let data = response.data, response.error == nil else {
                completion(.failure(LaunchServiceError.error))
                return
            }

            do {
                let launches = try JSONDecoder().decode(Launch.ListResponse.self, from: data)
                completion(.success(launches))
            } catch(let err) {
                print(err)
                completion(.failure(LaunchServiceError.invalidData))
            }
        }
    }

    func retrieveFetchLaunchesQueryData(limit: Int, offset: Int, filter: Filter.State?) -> Data {
        var filterQuery: Launch.Request.Query?
        var sort: Launch.Request.Options.Sort?
        if let filter = filter, filter.isFilterOn == true, let year = filter.selectedYear, let sortIndex = filter.selectedSortOrderIndex, let sortString = Filter.SortOptions(rawValue: sortIndex)?.string {
            filterQuery = Launch.Request.Query(date_utc: Launch.Request.Query.DateRange(year: year), success: true)
            sort = Launch.Request.Options.Sort(date_utc: sortString.lowercased())
        }

        let options = Launch.Request.Options(limit: limit, offset: offset, sort: sort)

        let query = Launch.Request(query: filterQuery, options: options)

        guard let data = try? JSONEncoder().encode(query) else {
            fatalError("Could not encode query to Json")
        }

        return data
    }
}
