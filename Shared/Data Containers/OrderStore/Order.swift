//
//  Order.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 5/07/2022.
//

import Foundation

/// Data structure to store information of individual orders such as names, date at which the order was made, notes, etc.
struct Order: Codable, Hashable {
    var orderId = UUID().uuidString
    var name: String
    var dateTime = Date.now
    var regularIngredients: [String]
    var extraIngredients: [String]
    var notes: String
    var quantity: Double
    
    var menuItem: MenuItem
    
    /// Creates an ``Order`` object when adding a new item to the order.
    init(menuItem: MenuItem) {
        self.name = ""
        self.regularIngredients = []
        self.extraIngredients = []
        self.notes = ""
        self.quantity = 0.0
        self.menuItem = menuItem
    }
    
    /// Creates a new ``Order`` object when in order editing mode.
    ///
    /// In this block, an ``Order`` is initialized when ``OrderCustomizerView`` is in editing mode.
    ///
    /// - Parameters:
    ///   - name: Name of the item being ordered
    ///   - regularIngredients: Ingredients in base order that has been ordered. **Does not include** ingredients that was not ordered.
    ///   - extraIngredients: Ingredients that has been ordered. **Does not include** ingredients that was not ordered.
    ///   - notes: Notes can be added for extra additional information
    ///   - quantity: Number of people who ordered the exact same item.
    ///   - menuItem: Corresponding ``MenuItem``. This ``MenuItem``object stores information about ingredients available
    init(name: String, regularIngredients: [String], extraIngredients: [String], notes: String, quantity: Double, menuItem: MenuItem) {
        self.name = name
        self.regularIngredients = regularIngredients
        self.extraIngredients = extraIngredients
        self.notes = notes
        self.quantity = quantity
        self.menuItem = menuItem
    }
}

var dummyOrder = Order(name: "Pizza", regularIngredients: ["Pesto Sauce"], extraIngredients: [""], notes: "Extra cheese", quantity: 1.0, menuItem: demoMenuItem_pasta)
