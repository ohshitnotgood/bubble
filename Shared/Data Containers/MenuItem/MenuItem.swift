//
//  MenuItem.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 26/06/2022.
//

import Foundation



/// `Codable` struct that represents an item on the menu.
struct MenuItem: Hashable, Codable {
    var id = UUID().uuidString
    var itemName: String
    var regularIngredients: [String]
    var warnings: [String]
    var extraIngredients: [String]
    var category: String
    
    init(itemName: String, regularIngredients: [String], warnings: [String], extraIngredients: [String], category: String) {
        self.itemName = itemName
        self.regularIngredients = regularIngredients
        self.warnings = warnings
        self.extraIngredients = extraIngredients
        self.category = category
    }
    
    
    /// Creates a new empty instance of ``MenuItem`` with empty string and empty lists.
    init() {
        self.itemName = ""
        self.regularIngredients = []
        self.extraIngredients = []
        self.warnings = []
        self.category = ""
    }
    
    func regularIngredientsAsString() -> String {
        var r = ""
        for (idx, each_ingredient) in self.regularIngredients.enumerated() {
            if idx == self.regularIngredients.endIndex - 1 {
                r += "and \(each_ingredient)"
            } else if idx == self.regularIngredients.endIndex - 2 {
                r += "\(each_ingredient) "
            } else {
                r += "\(each_ingredient), "
            }
        }
        
        return r
    }
    
    func warningsAsAString() -> String {
        var r = ""
        for (idx, each_warning) in self.warnings.enumerated() {
            if idx == self.warnings.endIndex - 1 {
                r += "and \(each_warning)"
            } else if idx == self.warnings.endIndex - 2 {
                r += "\(each_warning) "
            } else {
                r += "\(each_warning), "
            }
        }
        
        return r
    }
}

var demoMenuItem_pizza = MenuItem(itemName: "Pizza", regularIngredients: ["Tomato Sauce", "Mozzarella Cheese", "Chicken"], warnings: ["Gluten", "Lactose", "Non-veg/non-vegan"], extraIngredients: ["Pesto Sauce", "Sausages", "Ham", "Bacon"], category: "Pizzas")

var demoMenuItem_pasta = MenuItem(itemName: "Pasta", regularIngredients: ["Tomato Sauce", "Mozzarella Cheese", "Chicken"], warnings: ["Gluten", "Lactose", "Non-veg/non-vegan"], extraIngredients: ["Pesto Sauce", "Parmesan Cheese"], category: "Pastas")
