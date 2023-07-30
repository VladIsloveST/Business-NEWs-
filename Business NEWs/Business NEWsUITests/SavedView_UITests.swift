//
//  SavedView_UITests.swift
//  Business NEWsUITests
//
//  Created by Mac on 30.07.2023.
//

import XCTest

class SavedView_UITests: Business_NEWsUITests {

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
