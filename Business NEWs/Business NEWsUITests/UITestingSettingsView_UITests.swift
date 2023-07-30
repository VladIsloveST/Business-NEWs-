//
//  UITestingSettingsView_UITests.swift
//  Business NEWsUITests
//
//  Created by Mac on 30.07.2023.
//

import XCTest

class UITestingSettingsView_UITests: XCTestCase {
    
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
}
