//
//  StringPlaceholdersTest.swift
//  SpaceXTests
//
//  Created by David Beleza on 23/10/2021.
//

import XCTest
@testable import SpaceX

class StringPlaceholdersTest: XCTestCase {

    override func setUpWithError() throws { }

    override func tearDownWithError() throws { }

    func testFounderName() throws {
        var string = "The founder name is {founderName}"
        string.replacePlaceholder(.companyFounderName, withValue: "David")
        XCTAssertEqual(string, "The founder name is David")
    }

    func testYear() throws {
        var string = "The company was founded in year {year}"
        string.replacePlaceholder(.companyFoundedYear, withValue: "1988")
        XCTAssertEqual(string, "The company was founded in year 1988")
    }
}
