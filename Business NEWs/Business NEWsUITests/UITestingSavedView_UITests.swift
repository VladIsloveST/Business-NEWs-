//
//  UITestingSavedView_UITests.swift
//  Business NEWsUITests
//
//  Created by Mac on 30.07.2023.
//

import XCTest

class UITestingSavedView_UITests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                app.launch()
            }
        }
    }

    func test_UITestingSavedView_searchButton_showSearchBar() {
        app.tabBars["Tab Bar"].buttons["Saved"].tap()
        
        let savedNavigationBar = app.navigationBars["Saved"]
        let searchButton = savedNavigationBar.buttons["Search"]
        searchButton.tap()
        savedNavigationBar.children(matching: .staticText).matching(identifier: "Saved").element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .searchField).element.tap()
        searchButton.tap()
        let searchBar = savedNavigationBar.children(matching: .searchField).element
        
        XCTAssertFalse(searchBar.exists)
    }
}
