//
//  RatChamberUITests.swift
//  RatChamberUITests
//
//  Created by Yuto Mizutani on 2018/11/14.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import XCTest

class RatChamberUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        self.app = XCUIApplication()
        self.app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFR5() {
        let button = XCUIApplication().children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .button).matching(identifier: "Button").element(boundBy: 0)
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate,
                    evaluatedWith: button, handler: nil)
        waitForExpectations(timeout: 20, handler: nil)
        XCTAssert(button.exists)
        XCTAssertTrue(button.isSelected)

        button.tap()
        XCTAssertTrue(button.isSelected)
        button.tap()
        XCTAssertTrue(button.isSelected)
        button.tap()
        XCTAssertTrue(button.isSelected)
        button.tap()
        XCTAssertTrue(button.isSelected)
        button.tap()
        XCTAssertFalse(button.isSelected)

        sleep(6)
        button.tap()
        XCTAssertTrue(button.isSelected)
    }

}
