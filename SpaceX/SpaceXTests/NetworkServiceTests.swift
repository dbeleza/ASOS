//
//  NetworkServiceTests.swift
//  SpaceXTests
//
//  Created by David Beleza on 23/10/2021.
//

import XCTest
@testable import SpaceX

class NetworkServiceTests: XCTestCase {

    override func setUpWithError() throws {}

    override func tearDownWithError() throws {}

    func testBuildRequest_Success() throws {
        let sut = NetworkServiceImpl(environment: EnvironmentStub(), session: URLSession.shared)
        let request = SpaceXRequest.launchList(queryData: Data())
        let urlRequest = try? sut.buildUrlRequest(from: request)
        XCTAssertNotNil(urlRequest)
    }

    func testBuildRequest_Fail_Corrupt_Host() throws {
        let environmentCorruptHost = EnvironmentStub()
        environmentCorruptHost.host = "abc abc"
        let sut = NetworkServiceImpl(environment: environmentCorruptHost, session: URLSession.shared)
        let request = SpaceXRequest.launchList(queryData: Data())
        let urlRequest = try? sut.buildUrlRequest(from: request)
        XCTAssertNil(urlRequest)
    }
}
