//
//  SpaceXUITests.swift
//  SpaceXUITests
//
//  Created by David Beleza on 22/10/2021.
//

import XCTest
@testable import SpaceX

class SpaceXUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws { }

    func testBasicUI() throws {
        let app = XCUIApplication()
        app.launch()

        /*
         To do UITests, we should not be dependent from network. Mock data should be used.

         We could to this for example by doing something like this on our AppDelegate:

         let arguments = NSProcessInfo.processInfo().arguments
         let mock = arguments.contains("MOCKFLAG")
         if ( mock ) {
            // Mock Engine NetworkService
         }

         */
        // This is the most basic UITest
        XCTAssertTrue(app.activityIndicators[Accessibility.Screen.Launch.spinner].exists)
        XCTAssertTrue(app.navigationBars.buttons[Accessibility.Screen.Launch.filterButton].exists)
        waitForElementToAppear(element: app.tables[Accessibility.Screen.Launch.tableView])
    }

    func testFilterUI() throws {
        let app = XCUIApplication()
        app.launch()
        app.navigationBars.buttons[Accessibility.Screen.Launch.filterButton].tap()
        XCTAssertTrue(app.pickers[Accessibility.Screen.Filter.pickerView].exists)
    }

    private func waitForElementToAppear(element: XCUIElement, timeout: TimeInterval = 5,  file: String = #file, line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "exists == true")

        expectation(for: existsPredicate,
                       evaluatedWith: element, handler: nil)

        waitForExpectations(timeout: timeout) { (error) -> Void in
            if (error != nil) {
                let message = "Failed to find \(element) after \(timeout) seconds."
                let issue = XCTIssue(type: .assertionFailure, compactDescription: message)
                self.record(issue)
            }
        }
    }
}
