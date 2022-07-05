//
//  Order.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 5/07/2022.
//

import Foundation

/// Data structure to store information of individual orders such as names, date at which the order was made, notes, etc.
struct Order: Codable {
    var name: String
    var dateTime = Date.now
    var regularIngredients: [String]
    var extraIngredients: [String]
    var notes: String
    var quantity: Double
}

var dummyOrder = Order(name: "Pizza", regularIngredients: ["Pesto Sauce"], extraIngredients: [""], notes: "Extra cheese", quantity: 1.0)
