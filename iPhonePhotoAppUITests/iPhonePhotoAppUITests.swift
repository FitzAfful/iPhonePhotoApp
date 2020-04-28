//
//  iPhonePhotoAppUITests.swift
//  iPhonePhotoAppUITests
//
//  Created by Fitzgerald Afful on 28/04/2020.
//  Copyright © 2020 Fitzgerald Afful. All rights reserved.
//

import XCTest

class iPhonePhotoAppUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
    }

    func testOpenDetailFromVideoList() throws {

        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["3 Quick Ways To Open The iPhone Camera App"]/*[[".cells.buttons[\"3 Quick Ways To Open The iPhone Camera App\"]",".buttons[\"3 Quick Ways To Open The iPhone Camera App\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let labelElement = app.staticTexts["detailsLabel"]
        XCTAssert(labelElement.exists)
    }

    


}
