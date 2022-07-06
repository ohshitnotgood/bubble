//
//  Order.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 5/07/2022.
//

import Foundation

/// Data structure to store information of individual orders such as names, date at which the order was made, notes, etc.
struct Order: Codable, Hashable {
    var name: String
    var dateTime = Date.now
    var regularIngredients: [String]
    var extraIngredients: [String]
    var notes: String
    var quantity: Double
    
    init() {
        self.name = ""
        self.regularIngredients = []
        self.extraIngredients = []
        self.notes = ""
        self.quantity = 0.0
    }
    
    init(name: String, regularIngredients: [String], extraIngredients: [String], notes: String, quantity: Double) {
        self.name = name
        self.regularIngredients = regularIngredients
        self.extraIngredients = extraIngredients
        self.notes = notes
        self.quantity = quantity
    }
}

var dummyOrder = Order(name: "Pizza", regularIngredients: ["Pesto Sauce"], extraIngredients: [""], notes: "Extra cheese", quantity: 1.0)
