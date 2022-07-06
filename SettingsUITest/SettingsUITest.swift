//
//  SettingsUITest.swift
//  SettingsUITest
//
//  Created by Praanto Samadder on 3/07/2022.
//

import XCTest
import Fakery

class SettingsUITest: XCTestCase {
    
    let faker = Faker()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func test_MenuEditorView_addingNewItems() {
        
        let app = XCUIApplication()
        app.navigationBars["Edit Menu"].buttons["Add New Item"].tap()
        
        let tablesQuery2 = app.tables
        let tablesQuery = tablesQuery2
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Name"]/*[[".cells[\"Name\"].textFields[\"Name\"]",".textFields[\"Name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.textFields["Name"]/*[[".cells[\"Name\"].textFields[\"Name\"]",".textFields[\"Name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.typeText(faker.name.name())
        tablesQuery2.children(matching: .cell).matching(identifier: "Add ingredient...").element(boundBy: 0).children(matching: .other).element(boundBy: 0).children(matching: .other).element.tap()
        
        let regular_ingredients_text_field = tablesQuery/*@START_MENU_TOKEN@*/.textFields["Ingredient Name"]/*[[".cells[\"Ingredient Name\"].textFields[\"Ingredient Name\"]",".textFields[\"Ingredient Name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        
        regular_ingredients_text_field.tap()
        regular_ingredients_text_field.typeText(faker.address.city())
        // TODO: submit through keyboard
        
        
        
        tablesQuery2.children(matching: .cell).matching(identifier: "Add ingredient...").element(boundBy: 1).children(matching: .other).element(boundBy: 0).children(matching: .other).element.tap()
        tablesQuery2.cells["Ingredient Name"].textFields["Ingredient Name"].tap()
        tablesQuery2.cells["Gluten"].children(matching: .other).element(boundBy: 0).children(matching: .other).element.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Category"]/*[[".cells[\"Category\"].buttons[\"Category\"]",".buttons[\"Category\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery2.cells["Pizzas"].children(matching: .other).element(boundBy: 0).children(matching: .other).element.tap()
        app.navigationBars["Add Item to Menu"].buttons["Save"].tap()
    }
    
    func test_c() {
                
    }
    
    func test_MenuEditorView_updatingExistingItems() {
        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
