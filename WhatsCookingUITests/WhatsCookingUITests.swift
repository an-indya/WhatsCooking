//
//  WhatsCookingUITests.swift
//  WhatsCookingUITests
//
//  Created by Mandy Duvall on 8/22/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import XCTest

class WhatsCookingUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = true
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
    }
    
    func testFirstLaunch() {
        // Must clear all content and settings from simulator before running
        // On first load - should display the recipe browser and pull 10 recipes including a featured recipe
        let app = XCUIApplication()
        let mealsElement = app.navigationBars["Meals"].otherElements["Meals"]
        let loadButton = app.navigationBars["Meals"].buttons["Load More"]
        let featuredRecipe = app.staticTexts["Featured:"]
        let getRecipeButtom = app.buttons[" Get Recipe! "]
        let recipeCount = app.collectionViews.cells.count
        
        // verify that elements are present
        XCTAssertNotNil(mealsElement, "Meals header is not present")
        XCTAssertNotNil(loadButton)
        XCTAssertNotNil(featuredRecipe)
        XCTAssertNotNil(getRecipeButtom)
    
        XCTAssert(recipeCount == 10, "Recipe count is incorrect") // verifies that the correct number of recipes are populated
    }
    
    func testLoadMoreButton() {
        let app = XCUIApplication()
        let currentCount = app.collectionViews.cells.count
        
        app.navigationBars["Meals"].buttons["Load More"].tap()
        
        let newCount = app.collectionViews.cells.count
        
        assert(newCount == currentCount + 10)
        
    }
    
}
