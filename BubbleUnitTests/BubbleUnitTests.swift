//
//  BubbleUnitTests.swift
//  BubbleUnitTests
//
//  Created by Praanto Samadder on 6/07/2022.
//

import XCTest

class BubbleUnitTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_MenuItemStore_purgeItemList() throws {
        var items: [Int] = []
        items.sort()
        items.indices.forEach { idx in
            if items.last == items[idx] {
                return
            }
            if items.isEmpty {
                return
            }
            
            items[0] = 1
            items[idx + 1] = items[idx] + 1
        }
        XCTAssertTrue(items == [])
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
