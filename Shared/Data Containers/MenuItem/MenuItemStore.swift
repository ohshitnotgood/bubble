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
    func loadItems() async throws {
        do {
            let fileURL = try fileURL(for: .item)
            guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                return
            }
            try withAnimation {
                items = (try JSONDecoder().decode([MenuItem].self, from: file.availableData)).sorted {
                    $0.itemName < $1.itemName
                }
            }
        }
    }
    
    /// Saves ``MenuItemStore.items`` into device storage.
    func saveItems() async throws {
        do {
            let outfile = try fileURL(for: .item)
            let data = try JSONEncoder().encode(items)
            try data.write(to: outfile, options: .completeFileProtection)
            items.sort {
                $0.itemName < $1.itemName
            }
        }
    }
    
    /// Loads *categories* from device storage into ``MenuItemStore.categories``.
    func loadCategories() async throws {
        do {
            let fileURL = try fileURL(for: .category)
            guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                return
            }
            try withAnimation {
                categories = (try JSONDecoder().decode([String].self, from: file.availableData)).sorted {
                    $0 < $1
                }
            }
        }
    }

    
    /// Saves data stored in ``MenuItemStore.categories`` to local device.
    func saveCategories() async throws {
        do {
            let data = try JSONEncoder().encode(categories)
            let outfile = try fileURL(for: .category)
            try data.write(to: outfile, options: .completeFileProtection)
            categories.sort {
                $0 < $1
            }
        }
    }
    
    func saveIngredient(ingredientName name: String) async throws {
        
    }
    
    func loadIngredients() async throws {
        
    }
}

fileprivate enum FileURLSaveType: String {
    case item       = "menuItems.data"
    case ingredient = "menuIngredients.data"
    case category   = "menuCategory.data"
}
