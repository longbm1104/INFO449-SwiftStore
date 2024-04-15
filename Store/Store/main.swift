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
    
    func items() -> [SKU] {
        return self.itemsList
    }
    
    func output() -> String{
        var receiptStr = "Receipt:"
        
        for item in itemsList {
            receiptStr += "\n\(item.toString())"
        }
        
        receiptStr += "\n------------------\nTOTAL: $\(Float(total()) / 100.0)"
        
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

class Coupon {
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

class Register {
    var receipt: Receipt = Receipt()
    var subTotal: Int = 0
    var priceScheme: PricingScheme? = nil
    var coupon: Coupon? = nil
    
    
    func scan(_ item: SKU) {
        receipt.addItem(item: item)
        
        if (coupon != nil && coupon!.isEligible(item.name)) {
            self.subTotal += coupon!.applied(item: item)
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
