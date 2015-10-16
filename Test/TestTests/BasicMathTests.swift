//
//  BasicMathTests.swift
//  Test
//
//  Created by Brandon Titus on 10/16/15.
//
//

import XCTest

@testable import Test

class BasicMathTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAdding() {
        let basicMathInstance = BasicMath()
        XCTAssertEqual(basicMathInstance.add(1, 2), 1 + 2, "Adding should work")
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
