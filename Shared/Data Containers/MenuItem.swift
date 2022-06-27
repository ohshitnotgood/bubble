//
//  MenuItem.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 26/06/2022.
//

import Foundation

struct MenuItem: Hashable {
    var itemName: String
    var regularIngredients: [String]
    var warnings: [MenuItemWarnings]
    var extraIngredients: [String]
    
    
}

let menuItems = [
    MenuItem(
        itemName: "Grilled Cheese Sandwich",
        regularIngredients: ["Cheese", "White Bread"],
        warnings: [.dairy, .lactose, .gluten],
        extraIngredients: ["Brown Bread"]
    ),
    MenuItem(
        itemName: "Spaghetti",
        regularIngredients: ["Spaghetti", "Tomato Sauce", "Chicken", "Mozzarella Cheese"],
        warnings: [.meat, .dairy, .lactose],
        extraIngredients: ["Parmesan Cheese"]
    ),
    MenuItem(
        itemName: "Bruschetta",
        regularIngredients: ["Tomato Sauce", "Chicken", "Mozzarella Cheese", "Parmesan Cheese"],
        warnings: [.meat, .dairy, .lactose, .gluten],
        extraIngredients: ["Parmesan Cheese"]
    ),
    MenuItem(
        itemName: "Lasagna",
        regularIngredients: ["Flour", "Tomato Sauce", "Chicken", "Mozzarella Cheese"],
        warnings: [.meat, .dairy, .lactose, .highCarbs, .gluten],
        extraIngredients: ["Parmesan Cheese"]
    ),
    MenuItem(
        itemName: "Pizza",
        regularIngredients: ["Flour Dough", "Tomato Sauce", "Chicken", "Pepparoni"],
        warnings: [.meat, .dairy, .lactose, .gluten],
        extraIngredients: ["Parmesan Cheese", "Sausages"]
    )
]

enum MenuItemWarnings: String {
    case dairy      = "dairy"
    case meat       = "meat"
    case gluten     = "gluten"
    case highFat    = "high fat"
    case highCarbs  = "high carbs"
    case lactose    = "lactose"
    case peanuts    = "peanuts"
}
