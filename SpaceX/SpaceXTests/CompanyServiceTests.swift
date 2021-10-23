//
//  CompanyServiceTests.swift
//  SpaceXTests
//
//  Created by David Beleza on 23/10/2021.
//

import XCTest
@testable import SpaceX

class CompanyServiceTests: XCTestCase {
    let engine: EngineMock = EngineMock()
    let networkService: NetworkServiceStub = NetworkServiceStub()
    var sut: CompanyServiceImpl!

    override func setUpWithError() throws {
        engine.networkService = networkService
        sut = CompanyServiceImpl(engine: engine)
    }

    override func tearDownWithError() throws { }

    func testCompanySuccess_Response() throws {
        let path = Bundle(for: type(of: self)).path(forResource: "company_success", ofType: "json")
        let jsonData = try Data(contentsOf: URL(fileURLWithPath: path!))

        // Mock HTTP Response
        let urlResponse = HTTPURLResponse(url: URL(string: "http://spacex.com")!,
                                          statusCode: 200,
                                          httpVersion: nil,
                                          headerFields: nil)!
        networkService.response = (data: jsonData, urlResponse: urlResponse, error: nil)

        var result: Result<Company.Response, Error>?
        sut.fetchCompany { response in
            result = response
        }

        XCTAssertNotNil(result)

        guard case .success(let value) = result else {
            return XCTFail("Expected to be a success but got a failure with \(result!)")
        }

        let expectedResponse = Company.Response(name: "SpaceX",
                                                founder: "Elon Musk",
                                                founded: 2002,
                                                employees: 7000,
                                                launchSites: 3,
                                                valuation: 27500000000)

        XCTAssertEqual(value, expectedResponse)
    }

    func testCompanyNoSuccess_CorruptResponse() throws {
        let path = Bundle(for: type(of: self)).path(forResource: "company_corrupt", ofType: "json")
        let jsonData = try Data(contentsOf: URL(fileURLWithPath: path!))

        // Mock HTTP Response
        let urlResponse = HTTPURLResponse(url: URL(string: "http://spacex.com")!,
                                          statusCode: 200,
                                          httpVersion: nil,
                                          headerFields: nil)!
        networkService.response = (data: jsonData, urlResponse: urlResponse, error: nil)

        var result: Result<Company.Response, Error>?
        sut.fetchCompany { response in
            result = response
        }

        XCTAssertNotNil(result)

        guard case .failure(let error) = result else {
            return XCTFail("Expected to be a failure but got a success with \(result!)")
        }

        XCTAssertEqual(error as! CompanyServiceError, CompanyServiceError.invalidData)
    }

    func testCompanyErrorResponse() throws {
        // Mock HTTP Response
        let urlResponse = HTTPURLResponse(url: URL(string: "http://spacex.com")!,
                                          statusCode: 404,
                                          httpVersion: nil,
                                          headerFields: nil)!
        let error = NSError(domain: "", code: 404, userInfo: nil)
        networkService.response = (data: nil, urlResponse: urlResponse, error: error)

        var result: Result<Company.Response, Error>?
        sut.fetchCompany { response in
            result = response
        }

        XCTAssertNotNil(result)

        guard case .failure(let error) = result else {
            return XCTFail("Expected to be a failure but got a success with \(result!)")
        }

        XCTAssertEqual(error as! CompanyServiceError, CompanyServiceError.error)
    }
}
