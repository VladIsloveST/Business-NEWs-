//
//  Business_NEWsUITests.swift
//  Business NEWsUITests
//
//  Created by Mac on 10.02.2023.
//

import XCTest

class Business_NEWsUITests: XCTestCase {
    
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
    
    func test_UITestingContainerView_menuButton_showAndDismissMenu() {
        let navigationBar = app.navigationBars["Home"]
        let xAxisBeforeClicking = navigationBar.frame.origin.x
        
        navigationBar.buttons["drag"].tap()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Home"]/*[[".cells.staticTexts[\"Home\"]",".staticTexts[\"Home\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery.children(matching: .cell).element(boundBy: 2).staticTexts["Home"].tap()
        let xAxisAfterClicking = navigationBar.frame.origin.x
        
        XCTAssertEqual(xAxisBeforeClicking, xAxisAfterClicking)
    }

    func test_UITestingSettingsView_settingsButton_showAndDismissSettings() {
        let settingsButton = app.tabBars["Tab Bar"].buttons["Settings"]
        
        settingsButton.tap()
        app.buttons["Sheet Grabber"].swipeDown()
        let navBar =  app.navigationBars["Settings"].staticTexts["Settings"]
        XCTAssertFalse(navBar.exists)
        
        settingsButton.tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Thema"]/*[[".cells.staticTexts[\"Thema\"]",".staticTexts[\"Thema\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertFalse(navBar.exists)
    }
    
    func test_UITestingHomeView_searchBarButtonItem_showSearch() {
        let searchBarButtonItem = app.navigationBars["Home"].buttons["Search"]
        
        searchBarButtonItem.tap()
        let search = app.navigationBars["Search"]
        
        XCTAssertTrue(search.exists)
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
    
    func test_UITestingUITestingHomeView_tabBar_switch() {
        let tabBar = app.tabBars["Tab Bar"]
    
        let savedButton = tabBar.buttons["Saved"]
        savedButton.tap()
        let home = app.navigationBars["Home"]
        XCTAssertFalse(home.exists)
        
        let homeButton = tabBar.buttons["Home"]
        homeButton.tap()
        let saved = app.navigationBars["Saved"]
        XCTAssertFalse(saved.exists)
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
    
    func test_UITestingHomeView_moreButtonItem_showAndHideMenu() {
        let moreButtonItem = app.navigationBars["Home"].buttons["more"]
        
        moreButtonItem.tap()
        let collectionView = app.collectionViews/*@START_MENU_TOKEN@*/.cells.buttons["Copy"]/*[[".cells.buttons[\"Copy\"]",".buttons[\"Copy\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        collectionView.tap()
        
        XCTAssertFalse(collectionView.exists)
    }
}
