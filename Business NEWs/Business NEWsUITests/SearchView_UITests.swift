//
//  SearchView_UITests.swift
//  Business NEWsUITests
//
//  Created by Mac on 30.07.2023.
//

import XCTest

class SearchView_UITests: Business_NEWsUITests {
    
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
