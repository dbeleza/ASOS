//
//  LaunchListPresenterTests.swift
//  SpaceXTests
//
//  Created by David Beleza on 23/10/2021.
//

import XCTest
@testable import SpaceX

class LaunchListPresenterTests: XCTestCase {
    let launchStub = LaunchServiceStub()
    let companyStub = CompanyServiceStub()
    let viewController = LaunchListViewControllerMock()
    var sut: LaunchListPresenterImpl!

    override func setUpWithError() throws {
        sut = LaunchListPresenterImpl()
        sut.viewController = viewController
    }

    override func tearDownWithError() throws { }

    func testRetrieveCompany() throws {
        sut.interator(didRetrieveCompany: companyStub.companyResponse)
        let viewModel = Company.ViewModel(company: companyStub.companyResponse)
        let exp = expectation(description: "RetrieveCompany")
        let result = XCTWaiter.wait(for: [exp], timeout: 1.0)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(viewController.log, [.didRetrieveCompany(viewModel)])
        } else {
            XCTFail("Delay interrupted")
        }
    }

    func testRetrieveLaunches() throws {
        let launches = launchStub.listResponse
        sut.interator(didRetrieveLaunches: launches.list)
        let exp = expectation(description: "RetrieveLaunches")
        let result = XCTWaiter.wait(for: [exp], timeout: 1.0)
        if result == XCTWaiter.Result.timedOut {
            guard case .didRetrieveLaunchList(let viewModelArray) = viewController.log.first, let viewModel = viewModelArray.first else {
                return XCTFail("Expected to be .didRetrieveLaunchList")
            }
            XCTAssertEqual(viewModel.id, launches.list.first?.id)
        } else {
            XCTFail("Delay interrupted")
        }
    }

    func testRetrieveCompanyError() throws {
        sut.interatorDidRetrieveErrorCompany()
        let exp = expectation(description: "RetrieveCompanyError")
        let result = XCTWaiter.wait(for: [exp], timeout: 1.0)
        if result == XCTWaiter.Result.timedOut {
            guard case .didRetrieveCompanyError(let string) = viewController.log.first else {
                return XCTFail("Expected to be .didRetrieveCompanyError")
            }
            XCTAssertEqual(string, LocalizedString.error.localized)
        } else {
            XCTFail("Delay interrupted")
        }
    }

    func testRetrieveLaunchesError() throws {
        sut.interatorDidRetrieveErrorLaunches()
        let exp = expectation(description: "RetrieveCompanyError")
        let result = XCTWaiter.wait(for: [exp], timeout: 1.0)
        if result == XCTWaiter.Result.timedOut {
            guard case .didRetrieveLaunchListError(let string) = viewController.log.first else {
                return XCTFail("Expected to be .didRetrieveLaunchListError")
            }
            XCTAssertEqual(string, LocalizedString.error.localized)
        } else {
            XCTFail("Delay interrupted")
        }
    }
}
