//
//  LaunchListInteractorTests.swift
//  SpaceXTests
//
//  Created by David Beleza on 23/10/2021.
//

import XCTest
@testable import SpaceX

class LaunchListInteractorTests: XCTestCase {
    let engine: EngineMock = EngineMock()
    let launchService: LaunchServiceStub = LaunchServiceStub()
    let companyService: CompanyServiceStub = CompanyServiceStub()
    let launchListPresenter: LaunchListPresenterMock = LaunchListPresenterMock()
    var sut: LaunchListInteractor!

    override func setUpWithError() throws {
        engine.launchService = launchService
        engine.companyService = companyService
        sut = LaunchListInteractorImpl(engine: engine, presenter: launchListPresenter)
    }

    override func tearDownWithError() throws { }

    func testLoadScreen() throws {
        launchService.launchesResponse = .success(launchService.listResponse)
        companyService.response = .success(companyService.companyResponse)
        sut.loadScreen()

        XCTAssertEqual(launchListPresenter.log, [.didRetrieveCompany(companyService.companyResponse), .didRetrieveLaunches(launchService.listResponse.list)])
    }

    func testFetchCompany_Error() throws {
        companyService.response = .failure(CompanyServiceError.invalidData)
        sut.fetchCompanyDetails()

        XCTAssertEqual(launchListPresenter.log, [.didRetrieveErrorCompany])
    }

    func testFetchLaunches_Error() throws {
        launchService.launchesResponse = .failure(LaunchServiceError.invalidData)
        sut.fetchNextLaunches()

        XCTAssertEqual(launchListPresenter.log, [.didRetrieveErrorLaunches])
    }

    func testNoMoreFetch_If_Already_Have_TotalLaunches() throws {
        let listResponse = Launch.ListResponse(list: [Launch.ListResponse.Response(id: "1",
                                                                                   missionName: "Spacex",
                                                                                   launchDateUnix: 123456789,
                                                                                   launchSuccess: true,
                                                                                   metadata: Launch.ListResponse.Response.Metadata(images: Launch.ListResponse.Response.Metadata.Images(small: "",
                                                                                                                                                                                        large: ""),
                                                                                                                                   articleLink: "https://article.com",
                                                                                                                                   wikipediaLink: "https://wikipedia.com",
                                                                                                                                   youtubeLink: "https://youtube.com"),
                                                                                   rocket: Launch.ListResponse.Response.Rocket(name: "Fenix",
                                                                                                                               type: "F1"))],
                                               totalResults: 1)
        launchService.launchesResponse = .success(listResponse)
        sut.fetchNextLaunches()
        launchListPresenter.clearLog()

        sut.fetchNextLaunches()
        XCTAssertEqual(launchListPresenter.log, [])
    }

    func testResetLaunchesList_When_ApplyFilter() throws {
        launchService.launchesResponse = .success(launchService.listResponse)
        sut.applyFilter(isSuccess: true, year: "2010", isAscending: true)
        XCTAssertEqual(launchListPresenter.log, [.didResetLaunchesList, .didRetrieveLaunches(launchService.listResponse.list)])
    }

    func testApplySameFilter_Twice_And_LaunchListPresenter_JustTriggered_Once() throws {
        launchService.launchesResponse = .success(launchService.listResponse)

        sut.applyFilter(isSuccess: true, year: "2010", isAscending: true)
        sut.applyFilter(isSuccess: true, year: "2010", isAscending: true)

        XCTAssertEqual(launchListPresenter.log, [.didResetLaunchesList, .didRetrieveLaunches(launchService.listResponse.list)])
    }

    func testApplySameFilter_Twice_But_Just_Made_Request_API_Once() throws {
        let launchServiceMock = LaunchServiceMock()
        engine.launchService = launchServiceMock

        sut.applyFilter(isSuccess: true, year: "2010", isAscending: true)
        sut.applyFilter(isSuccess: true, year: "2010", isAscending: true)

        XCTAssertEqual(launchServiceMock.log, [.fetchLaunch])
    }

    func testFetchLaunch_While_Another_IsProcessing_Should_Only_Fetch_One() throws {
        launchService.launchesResponse = .success(launchService.listResponse)
        launchService.delayRequestSeconds = 0.5

        sut.fetchNextLaunches()
        sut.fetchNextLaunches()

        let exp = expectation(description: "FetchLaunches")
        let result = XCTWaiter.wait(for: [exp], timeout: 1.0)
        if result == XCTWaiter.Result.timedOut {
            XCTAssertEqual(launchListPresenter.log, [.didRetrieveLaunches(launchService.listResponse.list)])
        } else {
            XCTFail("Delay interrupted")
        }
    }
}
