//
//  main.swift
//  Store
//
//  Created by Ted Neward on 2/29/24.
//

import Foundation

protocol SKU {
    var name: String {get}
    func price() -> Int
    func toString() -> String
}

protocol PricingScheme {
    func adjustPrice(_ count: Int, _ unitPrice: Int) -> Int
}

protocol Coupon {
    var name: String {get}
    var itemName: String {get}
    var isUsed: Bool {get}
    
    func applied(item: SKU) -> Int
    func isEligible(_ itemName: String) -> Bool
}

class TwoForOnePricingScheme: PricingScheme {
    func adjustPrice(_ count: Int, _ unitPrice: Int) -> Int {
        let groupOfThree: Int = count / 3
        let remainder: Int = count % 3
        
        return groupOfThree * 2 * unitPrice  + remainder * unitPrice
    }
}

class Item: SKU {
    var name: String
    var itemPrice: Int
    
    init(name: String, priceEach: Int) {
        self.name = name
        self.itemPrice = priceEach
    }
    
    func price() -> Int{
        return self.itemPrice
    }
    
    func toString() -> String {
        return "\(name): $\(Float(itemPrice) / 100.0)"
    }
}

class ItemByWeight: SKU {
    var name: String
    var itemPrice: Int
    var weight: Double
    
    init(name: String, priceEach: Int, weight: Double=1.0) {
        self.name = name
        self.itemPrice = priceEach
        self.weight = weight
    }
    
    func price() -> Int{
        return Int(Double(self.itemPrice) * weight)
    }
    
    func toString() -> String {
        return "\(name) ($\(Float(itemPrice) / 100.0)/lbs): $\(Float(price()) / 100.0)"
    }
}

class Receipt {
    var itemsList: [SKU] = []
    var nameToCount: Dictionary<String, Int> = Dictionary<String, Int>()
    var finalTotal: Int = 0
    var couponName: String? = nil
    
    func items() -> [SKU] {
        return self.itemsList
    }
    
    func output() -> String{
        var receiptStr = "Receipt:"
        
        for item in itemsList {
            receiptStr += "\n\(item.toString())"
        }
        
        var couponDisplay = ""
        
        if couponName != nil {
            couponDisplay = "\nApplied Coupon '\(couponName!)' to your order"
        }
        
        receiptStr += "\(couponDisplay)\n------------------\nTOTAL: $\(Float(total()) / 100.0)"
        
        return receiptStr
    }
    
    func addItem(item: SKU) {
        self.itemsList.append(item)
        let name = item.name
        
        if (nameToCount[name] == nil) {
            nameToCount[name] = 0
        }
        
        nameToCount[name]! += 1
    }
    
    func total() -> Int {
        return self.finalTotal
    }
}

class Discount: Coupon {
    var name: String
    var discount: Double
    var itemName: String
    var isUsed: Bool = false
    
    init(name: String, discount: Double, itemName: String)  {
        self.name = name
        self.discount = discount
        self.itemName = itemName
    }
    
    func applied(item: SKU) -> Int {
        if (isEligible(item.name.lowercased()) && !isUsed) {
            isUsed = true
            return Int(Double(item.price()) * (1.0 - discount))
        }
        
        return item.price()
    }
    
    func isEligible(_ itemName: String) -> Bool {
        return itemName.contains(itemName) && !isUsed
    }
}

class RainCheck: Coupon {
    var name: String
    var coverage: Double
    var replacePrice: Int
    var itemName: String
    var isUsed: Bool = false
    
    init(name: String, coverage: Double, itemName: String, replacePrice: Int)  {
        self.name = name
        self.coverage = coverage
        self.itemName = itemName
        self.replacePrice = replacePrice
    }
    
    func applied(item: SKU) -> Int {
        if (isEligible(item.name.lowercased()) && !isUsed) {
            if let itemByWeight = item as? ItemByWeight {
                let amountApply: Double
                
                if (self.coverage <= itemByWeight.weight) {
                    amountApply = self.coverage
                } else {
                    amountApply = itemByWeight.weight
                }
                self.coverage -= amountApply
                
                if (self.coverage <= 0) {
                    isUsed = true
                }
                
                return Int(Double(replacePrice) * amountApply + Double(itemByWeight.itemPrice) * abs(itemByWeight.weight - amountApply))
            }
        }
        
        return item.price()
    }
    
    func isEligible(_ itemName: String) -> Bool {
        return self.itemName == itemName && !isUsed
    }
}

class Register {
    var receipt: Receipt = Receipt()
    var subTotal: Int = 0
    var priceScheme: PricingScheme? = nil
    var coupon: Coupon? = nil
    
    
    func scan(_ item: SKU) {
        receipt.addItem(item: item)
        
        if (coupon != nil && coupon!.isEligible(item.name.lowercased())) {
            self.subTotal += coupon!.applied(item: item)
            self.receipt.couponName = coupon!.name
        } else if (priceScheme == nil) {
            self.subTotal += item.price()
        } else {
            let count = self.receipt.nameToCount[item.name]!
            self.subTotal += (priceScheme!.adjustPrice(count, item.price()) - priceScheme!.adjustPrice(count - 1, item.price()))
        }
    }
    
    func subtotal() -> Int {
        return self.subTotal
    }
    
    func total() -> Receipt {
        self.receipt.finalTotal = self.subTotal
        return self.receipt
    }
    
}

class Store {
    let version = "0.1"
    func helloWorld() -> String {
        return "Hello world"
    }
}
