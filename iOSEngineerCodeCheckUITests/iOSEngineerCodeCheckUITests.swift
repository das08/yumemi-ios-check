//
//  iOSEngineerCodeCheckUITests.swift
//  iOSEngineerCodeCheckUITests
//
//  Created by Kazuki Takeda on 2022/02/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import XCTest

class iOSEngineerCodeCheckUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSearchRepository() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        app.tables.searchFields["GitHubのリポジトリを検索できるよー"].tap()
        app.searchFields["GitHubのリポジトリを検索できるよー"].typeText("Swift")
        app.buttons["Search"].tap()
        
        // Wait until its loaded
        sleep(4)

        let cell = app.tables.cells.element(boundBy: 0)
        XCTAssert(cell.exists)
        cell.tap()
        
        let shareButton = app.navigationBars.element(boundBy: 0).buttons["Share"]
        XCTAssert(shareButton.exists)
    }
}
