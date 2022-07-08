//
//  MenuItemStore.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 27/06/2022.
//


import SwiftUI


class MenuItemStore: ObservableObject {
    /// List of all items on the menu, **sorted by** `itemName`
    @Published var items: [MenuItem] = []
    @Published var categories: [String] = []
    @Published var ingredients: [String] = []
    @Published var warnings: [String] = ["Gluten", "Dairy", "Lactose"]
    
    @available(iOS, deprecated, message: "Use instead FileManager.defaults.getURL(for: FileURLType")
    private func fileURL(for pathComponent: FileURLSaveType) throws -> URL {
        let url = try FileManager.default.url(for: .documentDirectory,
                                              in: .userDomainMask,
                                              appropriateFor: nil,
                                              create: false)
        
        return url.appendingPathComponent(pathComponent.rawValue)
    }
    
    /// Loads `MenuItem`s from device storage onto ``MenuItemStore.items``.
    func loadItems() { Task {
        let fileURL = try FileManager.default.getURL(for: .items)
        guard let file = try? FileHandle(forReadingFrom: fileURL) else {
            return
        }
        try withAnimation {
            items = (try JSONDecoder().decode([MenuItem].self, from: file.availableData)).sorted {
                $0.itemName < $1.itemName
            }
            
        }
    }}
    
    /// Saves ``MenuItemStore.items`` into device storage.
    func saveItems() { Task {
        let outfile = try FileManager.default.getURL(for: .items)
        let data = try JSONEncoder().encode(items)
        try data.write(to: outfile, options: .completeFileProtection)
        items.sort {
            $0.itemName < $1.itemName
        }
    }}
    
    /// Loads *categories* from device storage into ``MenuItemStore.categories``.
    func loadCategories() { Task {
        let fileURL = try FileManager.default.getURL(for: .categories)
        guard let file = try? FileHandle(forReadingFrom: fileURL) else {
            return
        }
        try withAnimation {
            categories = (try JSONDecoder().decode([String].self, from: file.availableData)).sorted {
                $0 < $1
            }
        }
    }}
    
    
    /// Saves data stored in ``MenuItemStore.categories`` to local device.
    func saveCategories() { Task {
        let data = try JSONEncoder().encode(categories)
        let outfile = try FileManager.default.getURL(for: .categories)
        try data.write(to: outfile, options: .completeFileProtection)
        categories.sort {
            $0 < $1
        }
    }}
    
    func saveIngredient() { Task {
        loadIngredientsFromItems()
        let data = try JSONEncoder().encode(ingredients)
        let outfile = try FileManager.default.getURL(for: .ingredients)
        try data.write(to: outfile, options: .completeFileProtection)
        ingredients.sort {
            $0 < $1
        }
    }}
    
    func loadIngredients() { Task {
        let fileURL = try FileManager.default.getURL(for: .ingredients)
        guard let file = try? FileHandle(forReadingFrom: fileURL) else {
            return
        }
        try withAnimation {
            ingredients = (try JSONDecoder().decode([String].self, from: file.availableData)).sorted {
                $0 < $1
            }
        }
        loadIngredientsFromItems()
    }}
    
    func loadIngredientsFromItems() {
        items.forEach { each_item in
            each_item.regularIngredients.forEach {
                ingredients.appendIfNotContains($0)
            }
            
            each_item.extraIngredients.forEach {
                ingredients.appendIfNotContains($0)
            }
        }
    }
    
    func saveWarnings() { Task {
        let data = try JSONEncoder().encode(warnings)
        let outfile = try FileManager.default.getURL(for: .warnings)
        try data.write(to: outfile, options: .completeFileProtection)
        warnings.sort {
            $0 < $1
        }
    }}
    
    func loadWarnings() { Task {
        let fileURL = try FileManager.default.getURL(for: .warnings)
        guard let file = try? FileHandle(forReadingFrom: fileURL) else {
            return
        }
        try withAnimation {
            warnings = (try JSONDecoder().decode([String].self, from: file.availableData)).sorted {
                $0 < $1
            }
        }
    }}
    
    func loadAll() {
        loadItems()
        loadCategories()
        loadIngredients()
        loadWarnings()
    }
    
    func saveAll() {
        saveItems()
        saveCategories()
        saveIngredient()
        saveWarnings()
    }
}

fileprivate enum FileURLSaveType: String {
    case item       = "menuItems.data"
    case ingredient = "menuIngredients.data"
    case category   = "menuCategory.data"
    case warnings   = "menuWarnings.data"
}
