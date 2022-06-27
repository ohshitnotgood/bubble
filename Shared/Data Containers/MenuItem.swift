//
//  MenuItem.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 26/06/2022.
//

import Foundation



/// `Codable` struct that represents an item on the menu.
struct MenuItem: Hashable, Codable {
    var itemName: String
    var regularIngredients: [String]
    var warnings: [String]
    var extraIngredients: [String]
    var category: String
    
    init(itemName: String, regularIngredients: [String], warnings: [MenuItemWarnings], extraIngredients: [String], category: MenuItemCategory) {
        self.itemName = itemName
        self.regularIngredients = regularIngredients
        self.warnings = []
        self.extraIngredients = extraIngredients
        self.category = category.rawValue
        
        regularIngredients.forEach { ingredient in
            self.regularIngredients.append(ingredient)
        }
        
        warnings.forEach({ each_warning in
            self.warnings.append(each_warning.rawValue)
        })
    }
}

/// A list of ``MenuItem`` containing dummy data.
var menuItems = [
    MenuItem(
        itemName: "Grilled Cheese Sandwich",
        regularIngredients: ["Cheese", "White Bread"],
        warnings: [.dairy, .lactose, .gluten],
        extraIngredients: ["Brown Bread"],
        category: .appetizer
    ),
    MenuItem(
        itemName: "Spaghetti",
        regularIngredients: ["Spaghetti", "Tomato Sauce", "Chicken", "Mozzarella Cheese"],
        warnings: [.meat, .dairy, .lactose],
        extraIngredients: ["Parmesan Cheese"],
        category: .mainCourse
    ),
    MenuItem(
        itemName: "Bruschetta",
        regularIngredients: ["Tomato Sauce", "Chicken", "Mozzarella Cheese", "Parmesan Cheese"],
        warnings: [.meat, .dairy, .lactose, .gluten],
        extraIngredients: ["Parmesan Cheese"],
        category: .mainCourse
    ),
    MenuItem(
        itemName: "Lasagna",
        regularIngredients: ["Flour", "Tomato Sauce", "Chicken", "Mozzarella Cheese"],
        warnings: [.meat, .dairy, .lactose, .highCarbs, .gluten],
        extraIngredients: ["Parmesan Cheese"],
        category: .mainCourse
    ),
    MenuItem(
        itemName: "Pizza",
        regularIngredients: ["Flour Dough", "Tomato Sauce", "Chicken", "Pepparoni"],
        warnings: [.meat, .dairy, .lactose, .gluten],
        extraIngredients: ["Parmesan Cheese", "Sausages"],
        category: .mainCourse
    ),
    MenuItem(
        itemName: "Pasta",
        regularIngredients: ["Flour Dough", "Eggs", "Tomato Sauce", "Chicken", "Pepparoni"],
        warnings: [.meat, .dairy, .lactose, .gluten],
        extraIngredients: ["Parmesan Cheese", "Sausages"],
        category: .mainCourse
    ),
    MenuItem(
        itemName: "Garlic Bread",
        regularIngredients: ["Bread", "Mozzerella Cheese", "Garlic", "Tomato Sauce"],
        warnings: [.lactose, .dairy, .gluten],
        extraIngredients: [],
        category: .appetizer
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

enum MenuItemCategory: String {
    case mainCourse = "Main Course"
    case appetizer  = "Appetizer"
    case beverage   = "Beverage"
}

struct MenuItemIngredient: Hashable, Codable {
    var customerDidOrder = false
    var name: String
    
    func getObservableObject() -> ObservableIngredient {
        return ObservableIngredient(self.name)
    }
}

class ObservableIngredient: ObservableObject {
    @Published var name: String
    @Published var customerDidOrder = false
    
    init(_ name: String) {
        self.name = name
    }
}
