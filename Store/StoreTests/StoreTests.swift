//
//  StoreTests.swift
//  StoreTests
//
//  Created by Ted Neward on 2/29/24.
//

import XCTest
final class StoreTests: XCTestCase {

    var register = Register()

    override func setUpWithError() throws {
        register = Register()
    }

    override func tearDownWithError() throws { }

    func testBaseline() throws {
        XCTAssertEqual("0.1", Store().version)
        XCTAssertEqual("Hello world", Store().helloWorld())
    }
    
    func testOneItem() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(199, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
------------------
TOTAL: $1.99
"""
        print(receipt.output())
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    //New test for how the receipt will be printed for 3 items that are the same. This one doesn't have the promo buy 2 get 1 yet
    func testThreeSameItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199 * 3, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(199 * 3, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
Beans (8oz Can): $1.99
Beans (8oz Can): $1.99
------------------
TOTAL: $5.97
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    func testThreeDifferentItems() {
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199, register.subtotal())
        register.scan(Item(name: "Pencil", priceEach: 99))
        XCTAssertEqual(298, register.subtotal())
        register.scan(Item(name: "Granols Bars (Box, 8ct)", priceEach: 499))
        XCTAssertEqual(797, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(797, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
Pencil: $0.99
Granols Bars (Box, 8ct): $4.99
------------------
TOTAL: $7.97
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    //New test for two same items and 1 different item
    func testTwoSameOneDifferent() {
        register.scan(Item(name: "Strawberry (2 pounds)", priceEach: 399))
        XCTAssertEqual(399, register.subtotal())
        register.scan(Item(name: "Granols Bars (Box, 8ct)", priceEach: 499))
        XCTAssertEqual(898, register.subtotal())
        register.scan(Item(name: "Granols Bars (Box, 8ct)", priceEach: 499))
        XCTAssertEqual(1397, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(1397, receipt.total())

        let expectedReceipt = """
Receipt:
Strawberry (2 pounds): $3.99
Granols Bars (Box, 8ct): $4.99
Granols Bars (Box, 8ct): $4.99
------------------
TOTAL: $13.97
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    //New test scanning 2 same items in different order and 2 different items
    func testTwoAlternativeTwoDifferent() {
        register.scan(Item(name: "Lettuce", priceEach: 329))
        XCTAssertEqual(329, register.subtotal())
        register.scan(Item(name: "Mango (1 count)", priceEach: 299))
        XCTAssertEqual(628, register.subtotal())
        register.scan(Item(name: "Cucumber", priceEach: 199))
        XCTAssertEqual(827, register.subtotal())
        register.scan(Item(name: "Mango (1 count)", priceEach: 299))
        XCTAssertEqual(1126, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(1126, receipt.total())

        let expectedReceipt = """
Receipt:
Lettuce: $3.29
Mango (1 count): $2.99
Cucumber: $1.99
Mango (1 count): $2.99
------------------
TOTAL: $11.26
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    //New test for how the receipt will be printed for 3 items that are the same. This one doesn't have the promo buy 2 get 1 yet
    func testThreeSameItemsWith2For1Promo() {
        let twoForOnePromo = TwoForOnePricingScheme()
        
        register.priceScheme = twoForOnePromo
        
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199 * 2, register.subtotal())
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199 * 2, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(199 * 2, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
Beans (8oz Can): $1.99
Beans (8oz Can): $1.99
------------------
TOTAL: $3.98
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    //New test for how the receipt will be printed for 5 items that are the same. This one doesn't have the promo buy 2 get 1 yet
    func testFiveSameItemsWith2For1Promo() {
        let twoForOnePromo = TwoForOnePricingScheme()
        
        register.priceScheme = twoForOnePromo
        
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199 * 2, register.subtotal())
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199 * 2, register.subtotal())
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199 * 3, register.subtotal())
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199 * 4, register.subtotal())
        
        let receipt = register.total()
        XCTAssertEqual(199 * 4, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
Beans (8oz Can): $1.99
Beans (8oz Can): $1.99
Beans (8oz Can): $1.99
Beans (8oz Can): $1.99
------------------
TOTAL: $7.96
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
    
    //New test for how the receipt will be printed for 5 items that are the same. This one doesn't have the promo buy 2 get 1 yet
    func testMixedItemsWith2For1Promo() {
        let twoForOnePromo = TwoForOnePricingScheme()
        
        register.priceScheme = twoForOnePromo
        
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199 * 2, register.subtotal()) // The promo should not kick in yet
        register.scan(Item(name: "Mango (1 count)", priceEach: 299))
        XCTAssertEqual(199 * 2 + 299, register.subtotal()) // Here we add a different items so the mango wouldn't kick in
        register.scan(Item(name: "Beans (8oz Can)", priceEach: 199))
        XCTAssertEqual(199 * 2 + 299, register.subtotal()) // Here we add a third Beans (8oz Can), so the promo kick in
        register.scan(Item(name: "Cucumber", priceEach: 199))
        XCTAssertEqual(199 * 2 + 299 + 199, register.subtotal()) // Here we add a new item so the promo is not kick in.
        
        let receipt = register.total()
        XCTAssertEqual(199 * 2 + 299 + 199, receipt.total())

        let expectedReceipt = """
Receipt:
Beans (8oz Can): $1.99
Beans (8oz Can): $1.99
Mango (1 count): $2.99
Beans (8oz Can): $1.99
Cucumber: $1.99
------------------
TOTAL: $8.96
"""
        XCTAssertEqual(expectedReceipt, receipt.output())
    }
}
