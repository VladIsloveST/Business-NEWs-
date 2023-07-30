//
//  UITestingSearchView_UITests.swift
//  Business NEWsUITests
//
//  Created by Mac on 30.07.2023.
//

import XCTest

class UITestingSearchView_UITests: XCTestCase {

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
    
    func test_UITestingSearchView_searchField_showAndHideSearchHistory() {
        let searchBarButtonItem = app.navigationBars["Home"].buttons["Search"]
        
        searchBarButtonItem.tap()
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.searchFields[" Search..."].tap()
        let tablesQuery = app.tables.matching(identifier: "historyTableView")
        XCTAssertTrue(tablesQuery.element.exists)
        collectionViewsQuery.element.tap()
        
        XCTAssertFalse(tablesQuery.element.exists)
    }
    
    func test_UITestingSearshView_backButtonItem_popToRoot() {
        let searchBarButtonItem = app.navigationBars["Home"].buttons["Search"]
        
        searchBarButtonItem.tap()
        let search = app.navigationBars["Search"]
        let backButtonItem = app.navigationBars["Search"].buttons["Back"]
        backButtonItem.tap()
        
        XCTAssertFalse(search.exists)
    }
}
