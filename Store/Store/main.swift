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
}

class Receipt {
    var itemsList: [SKU] = []
    var subTotal: Int = 0
    
    func items() -> [SKU] {
        return self.itemsList
    }
    
    func output() -> String{
        var receiptStr = "Receipt:"
        
        for item in itemsList {
            receiptStr += "\n\(item.name): $\(Float(item.price()) / 100.0)"
        }
        
        receiptStr += "\n------------------\nTOTAL: $\(Float(total()) / 100.0)"
        
        return receiptStr
    }
    
    func addItem(item: SKU) {
        self.itemsList.append(item)
        self.subTotal += item.price()
    }
    
    func total() -> Int {
        return self.subTotal
    }
}

class Register {
    var receipt: Receipt = Receipt()
    
    
    func scan(_ item: SKU) {
        receipt.addItem(item: item)
    }
    
    func subtotal() -> Int {
        return self.receipt.total()
    }
    
    func total() -> Receipt {
        return self.receipt
    }
    
}

class Store {
    let version = "0.1"
    func helloWorld() -> String {
        return "Hello world"
    }
}
