//
//  IntDateTest.swift
//  SpaceXTests
//
//  Created by David Beleza on 23/10/2021.
//

import XCTest
@testable import SpaceX

class IntDateTest: XCTestCase {

    override func setUpWithError() throws { }

    override func tearDownWithError() throws { }

    func testSameDate() throws {
        let dateUnix = 1666196394
        let date = Date(timeIntervalSince1970: TimeInterval(dateUnix))
        XCTAssertEqual(dateUnix.differenceBetweenDate(date), 0)
    }

    func testFromOneDayDifference() throws {
        let dateUnix = 1666196394
        let date = Date(timeIntervalSince1970: TimeInterval(1666109994))
        XCTAssertEqual(dateUnix.differenceBetweenDate(date), 1)
    }

    func testSinceOneDayDifference() throws {
        let dateUnix = 1666109994
        let date = Date(timeIntervalSince1970: TimeInterval(1666196394))
        XCTAssertEqual(dateUnix.differenceBetweenDate(date), -1)
    }
}
