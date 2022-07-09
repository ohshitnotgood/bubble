//
//  MenuItem.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 26/06/2022.
//

import Foundation



/// `Codable` struct that represents an item on the menu.
///
/// `MenuItem`s store information about individual items on the menu.
///
/// When ever a new item is added to the menu, it is done so by instantiating a new `MenuItem` object and appending it to
/// `items` list inside ``MenuItemStore``.
///
/// Information stored are:
/// - `id`
/// - `itemNumber`
/// - `itemName`
/// - `regularIngredients`
/// - `extraIngredients`
/// - `warnings`
/// - `category`
///
/// A `MenuItem` is only allowed to be editted inside ``MenuItemEditorView``, although this restriction is not programmatically
/// strict.
///
/// When initialized without any parameters, every member is either a blank string/list. Checks are, therefore, implemented inside
/// ``MenuEditorView`` to ensure blank items are not saved into the menu.
///
/// *Last updated: 8 June 2022 at 22:07*
struct MenuItem: Hashable, Codable {
    var id = UUID().uuidString
    
    /// Index of the dish on the restaurant menu.
    var itemNumber: Int
    
    /// Name of the dish.
    var itemName: String
    
    /// Ingredients/toppings the dish is regularly served with.
    var regularIngredients: [String]
    
    /// Warnings (e.g. containing gluten, lactose, etc) that customsers should be made aware of.
    var warnings: [String]
    
    /// Extra ingredients/toppings the customsers are allowed to request with this dish.
    var extraIngredients: [String]
    
    /// Category (e.g. Main Course, Drinks) in which this item belongs.
    var category: String
    
    /// Creates a ``MenuItem`` object with provided parameters.
    ///
    /// Should only be instantited this way when editing an item already on the list.
    ///
    /// *Last updated: 8 June 2022 at 22:11*
    init(itemName: String, regularIngredients: [String], warnings: [String], extraIngredients: [String], category: String) {
        self.itemName = itemName
        self.itemNumber = UserDefaults().integer(forKey: "next_increment")
        self.regularIngredients = regularIngredients
        self.warnings = warnings
        self.extraIngredients = extraIngredients
        self.category = category
        self.itemNumber = MenuItemStore().largestItemNumber
        
    }
    
    
    /// Creates a new empty instance of ``MenuItem`` with empty string and empty lists.
    ///
    ///
    /// Should only be instantiated this way when adding a new item in the menu.
    ///
    /// Creating an instance of `MenuItem` like this is unsafe since checks are implemented only in the view to ensure to
    /// empty items are wrongly added to the menu.
    ///
    ///
    /// *Last updated: 8 June 2022 at 22:10*
    init() {
        self.itemNumber = 0
        self.itemName = ""
        self.regularIngredients = []
        self.extraIngredients = []
        self.warnings = []
        self.category = ""
    }
    
    static let pizza = MenuItem(itemName: "Pizza", regularIngredients: ["Tomato Sauce", "Mozzarella Cheese", "Chicken"], warnings: ["Gluten", "Lactose", "Non-veg/non-vegan"], extraIngredients: ["Pesto Sauce", "Sausages", "Ham", "Bacon"], category: "Pizzas")
    
    static let pasta = MenuItem(itemName: "Pasta", regularIngredients: ["Tomato Sauce", "Carbonara Cream", "Chicken"], warnings: ["Gluten", "Lactose", "Non-veg/non-vegan"], extraIngredients: ["Parmesan Cheese", "Cheddar Cheese", "Sausages", "Olives"], category: "Pastas")

}
