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
    
    private func fileURL(for pathComponent: FileURLSaveType) throws -> URL {
        let url = try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        
        return url.appendingPathComponent(pathComponent.rawValue)
    }
    
    /// Loads `MenuItem`s from device storage onto ``MenuItemStore.items``.
    func load() async throws {
        do {
            let fileURL = try fileURL(for: .item)
            guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                return
            }
            items = (try JSONDecoder().decode([MenuItem].self, from: file.availableData)).sorted {
                $0.itemName < $1.itemName
            }
        }
    }
    
    /// Saves ``MenuItemStore.items`` into device storage.
    func save() async throws {
        do {
            let outfile = try fileURL(for: .item)
            let data = try JSONEncoder().encode(items)
            try data.write(to: outfile, options: .completeFileProtection)
        }
    }
    
    func loadCategories() async throws {
        do {
            let fileURL = try fileURL(for: .category)
            guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                return
            }
            categories = (try JSONDecoder().decode([String].self, from: file.availableData)).sorted {
                $0 < $1
            }
        }
    }
    
    func saveCategory(categoryName newCategory: String) async throws {
        do {
            categories.append(newCategory)
            let data = try JSONEncoder().encode(categories)
            
            let outfile = try fileURL(for: .category)
            try data.write(to: outfile, options: .completeFileProtection)
        }
    }
    
    func updateCategories() async throws {
        try await load()
        try await loadCategories()
        
        for each_item in self.items {
            categories.appendIfNotContains(each_item.category)
        }
    }
    
    func updateIngredients() async throws {
        try await load()
        try await loadIngredients()
        
        for each_item in items {
            each_item.regularIngredients.forEach { each_ingredient in
                ingredients.appendIfNotContains(each_ingredient)
            }
            
            each_item.extraIngredients.forEach { each_ingredient in
                ingredients.appendIfNotContains(each_ingredient)
            }
        }
    }
    
    func addIngredient(ingredientName name: String) async throws {
        
    }
    
    func loadIngredients() async throws {
        
    }
}

fileprivate enum FileURLSaveType: String {
    case item       = "menuItems.data"
    case ingredient = "menuIngredients.data"
    case category   = "menuCategory.data"
}
