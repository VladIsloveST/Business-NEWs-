//
//  ContainerView_UITests.swift
//  Business NEWsUITests
//
//  Created by Mac on 29.07.2023.
//

import XCTest

class ContainerView_UITests: Business_NEWsUITests {
    
    func test_UITestingContainerView_articlesCollectionView_scrollAndTap() {
        let menuCollectionView = app.collectionViews
        let articlesCollectionView = app.collectionViews.matching(identifier: "articlesCollectionView")
        
       

        menuCollectionView.staticTexts["Apple"].tap()
        menuCollectionView.staticTexts["TechCrunch"].tap()
                
  //      print(menuCollectionView.cells.accessibilityPath?.bound)

        articlesCollectionView.element.swipeRight()
        articlesCollectionView.element.swipeRight()
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
    
    func test_UITestingHomeView_searchBarButtonItem_showSearch() {
        let searchBarButtonItem = app.navigationBars["Home"].buttons["Search"]
        
        searchBarButtonItem.tap()
        let search = app.navigationBars["Search"]
        
        XCTAssertTrue(search.exists)
    }
    
    func test_UITestingHomeView_tabBar_switch() {
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
    
    
    func test_UITestingHomeView_moreButtonItem_showAndHideMenu() {
        let moreButtonItem = app.navigationBars["Home"].buttons["more"]
        
        moreButtonItem.tap()
        let collectionView = app.collectionViews/*@START_MENU_TOKEN@*/.cells.buttons["Copy"]/*[[".cells.buttons[\"Copy\"]",".buttons[\"Copy\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        collectionView.tap()
        
        XCTAssertFalse(collectionView.exists)
    }
}
