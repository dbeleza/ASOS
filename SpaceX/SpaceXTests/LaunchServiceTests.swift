//
//  SpaceXTests.swift
//  SpaceXTests
//
//  Created by David Beleza on 22/10/2021.
//

import XCTest
@testable import SpaceX

class LaunchServiceTests: XCTestCase {
    let engine: EngineMock = EngineMock()
    let networkService: NetworkServiceStub = NetworkServiceStub()
    var sut: LaunchServiceImpl!

    override func setUpWithError() throws {
        engine.networkService = networkService
        sut = LaunchServiceImpl(engine: engine)
    }

    override func tearDownWithError() throws {}

    func testLaunchSuccess_Response() throws {
        let path = Bundle(for: type(of: self)).path(forResource: "launch_success", ofType: "json")
        let jsonData = try Data(contentsOf: URL(fileURLWithPath: path!))

        // Mock HTTP Response
        let urlResponse = HTTPURLResponse(url: URL(string: "http://spacex.com")!,
                                          statusCode: 200,
                                          httpVersion: nil,
                                          headerFields: nil)!
        networkService.response = (data: jsonData, urlResponse: urlResponse, error: nil)

        var result: Result<Launch.ListResponse, Error>?
        let expectation = self.expectation(description: "testLaunchSuccess_Response")
        sut.fetchLaunches(limit: 50, offset: 0, filter: nil) { response in
            result = response
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertNotNil(result)

        guard case .success(let value) = result else {
            return XCTFail("Expected to be a success but got a failure with \(result!)")
        }

        XCTAssertEqual(value.list.count, 50)
    }

    func testLaunchNoSuccess_CorruptResponse() throws {
        let path = Bundle(for: type(of: self)).path(forResource: "launch_corrupt", ofType: "json")
        let jsonData = try Data(contentsOf: URL(fileURLWithPath: path!))

        // Mock HTTP Response
        let urlResponse = HTTPURLResponse(url: URL(string: "http://spacex.com")!,
                                          statusCode: 200,
                                          httpVersion: nil,
                                          headerFields: nil)!
        networkService.response = (data: jsonData, urlResponse: urlResponse, error: nil)

        var result: Result<Launch.ListResponse, Error>?
        let expectation = self.expectation(description: "fetchLaunches")
        sut.fetchLaunches(limit: 50, offset: 0, filter: nil) { response in
            result = response
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertNotNil(result)

        guard case .failure(let error) = result else {
            return XCTFail("Expected to be a failure but got a success with \(result!)")
        }

        XCTAssertEqual(error as! LaunchServiceError, LaunchServiceError.invalidData)
    }

    func testLaunchErrorResponse() throws {

        // Mock HTTP Response
        let urlResponse = HTTPURLResponse(url: URL(string: "http://spacex.com")!,
                                          statusCode: 404,
                                          httpVersion: nil,
                                          headerFields: nil)!
        let error = NSError(domain: "", code: 404, userInfo: nil)
        networkService.response = (data: nil, urlResponse: urlResponse, error: error)

        var result: Result<Launch.ListResponse, Error>?
        let expectation = self.expectation(description: "testLaunchErrorResponse")
        sut.fetchLaunches(limit: 50, offset: 0, filter: nil) { response in
            result = response
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 0.5)
        XCTAssertNotNil(result)

        guard case .failure(let error) = result else {
            return XCTFail("Expected to be a failure but got a success with \(result!)")
        }

        XCTAssertEqual(error as! LaunchServiceError, LaunchServiceError.error)
    }

    func testLaunchesQuery() throws {
        let expectedResult = "{\"query\":{\"success\":true,\"date_utc\":{\"$lte\":\"2020-12-31T23:59:59.000Z\",\"$gte\":\"2020-01-01T00:00:00.000Z\"}},\"options\":{\"populate\":{\"path\":\"rocket\",\"select\":[\"name\",\"type\"]},\"offset\":0,\"sort\":\"-date_utc\",\"select\":[\"name\",\"date_unix\",\"links\",\"success\"],\"limit\":50}}"
        let data = sut.retrieveFetchLaunchesQueryData(limit: 50, offset: 0, filter: Filter.State(isSuccess: true, selectedYear: "2020", isAscending: false))
        guard let dataStringify = String(data: data, encoding: .utf8) else {
            return XCTFail("Something went wrong while stringify data")
        }
        XCTAssertEqual(dataStringify, expectedResult)
    }
}
