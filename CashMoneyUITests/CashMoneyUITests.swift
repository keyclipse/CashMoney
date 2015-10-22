//
//  CashMoneyUITests.swift
//  CashMoneyUITests
//
//  Created by Samuel Kitono on 19/10/2015.
//  Copyright © 2015 Samuel Kitono. All rights reserved.
//

import XCTest

class CashMoneyUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate(timeIntervalSinceNow:3))
        
        
        let app = XCUIApplication()
        let inputcurrencyfieldTextField = app.textFields["InputCurrencyField"]
        inputcurrencyfieldTextField.tap()
        inputcurrencyfieldTextField.typeText("5000")
        app.typeText("\n")
        
        let inputString = inputcurrencyfieldTextField.value as! String
        
        let equalString = (inputString == "$50.00")
        XCTAssertTrue(equalString)
        
        
        
        //There is no straightforward way to test this UILabel should have used UITextField
        /*
        let outputCurrencyLabel = app.staticTexts["OutputCurrencyLabel"]
        let outputString = outputCurrencyLabel.value as! String
        XCTAssertEqual(outputCurrencyLabel, nil)
        */
        
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.staticTexts["CAD"].swipeLeft()
        collectionViewsQuery.staticTexts["EUR"].swipeLeft()
        collectionViewsQuery.staticTexts["GBP"].swipeLeft()
        collectionViewsQuery.staticTexts["JPY"].swipeLeft()
        
    }
    
}
