//
//  UITestingContainerView_UITests.swift
//  Business NEWsUITests
//
//  Created by Mac on 29.07.2023.
//

import XCTest

class UITestingContainerView_UITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
        app.launch()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func test_UITestingContainerView_articlesCollectionView_scrollAndTap() {
        let menuCollectionView = app.collectionViews
        let articlesCollectionView = app.collectionViews.matching(identifier: "articlesCollectionView")

        menuCollectionView.staticTexts["Apple"].tap()
        menuCollectionView.staticTexts["TechCrunch"].tap()

        articlesCollectionView.element.swipeRight()
        articlesCollectionView.element.swipeRight()
    }
}
