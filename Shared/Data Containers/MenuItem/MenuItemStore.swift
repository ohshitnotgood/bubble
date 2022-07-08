//
//  MenuItemStore.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 27/06/2022.
//


import SwiftUI



/// Stores information about the items on the menu and provides with functions to save and restore data from device storage.
///
/// Information about the items are encapsulated inside ``MenuItem`` objects.
///
/// In this app, `MenuItemStore` is passed from view to view as an `EnvironmentObject`. By doing so this way, every view has access to
/// only a single source of truth. For this reason, `MenuItemStore` is only declared in ``BubbleApp.swift``.
///
/// `MenuItemStore` exposes the following lists as members:
/// - `items: [MenuItem]`
/// - `categories: String`
/// - `ingredients: String`
/// - `warnings: String`
///
/// Alongside these members are exposed a pair of save and load functions (e.g. `loadItems()`, `saveItems()`. All such functions are `async` and are called everywhere inside a `Task` block.
///
/// Data is not auto-saved to device and hence the corresponding *save* function must be called inorder to retain persistence. In a future release, data will be made to autosave upon any change.
///
///
/// ``MenuItemEditorView`` has permission to make changes to the data inside this object, although this restriction is not programmatically strict.
///
/// ``MenuItemStore``, alongwith ``OrderStore`` and ``SettingsStore`` are the three `EnvironmentObject`s used in this app.
///
/// *Last updated: July 8, 2022 at 20:13*
class MenuItemStore: ObservableObject {
    /// List of all items on the menu, **sorted by** `itemName`
    @Published var items: [MenuItem] = []
    @Published var categories: [String] = []
    @Published var ingredients: [String] = []
    @Published var warnings: [String] = ["Gluten", "Dairy", "Lactose"]
    
    /// Refreshes ``items`` with data from device.
    ///
    /// Throughout the app's lifecycle, this function is called from ``ContentView`` inside `.onAppear` block.
    /// This is because, as a result of being passed around as an `EnvironmentObject` and that the data in ``items`` is only ever
    /// changed in ``MenuItemEditorView``, every `view` that needs it already has the most up-to-date data.
    ///
    ///
    /// *Last updated: July 8, 2022 at 22:16*
    func loadItems() async throws {
        let fileURL = try FileManager.default.getURL(for: .items)
        guard let file = try? FileHandle(forReadingFrom: fileURL) else {
            return
        }
        try withAnimation {
            items = (try JSONDecoder().decode([MenuItem].self, from: file.availableData)).sorted {
                $0.itemName < $1.itemName
            }
            
        }
    }
    
    /// Saves ``items`` into device storage and sorts list alphabetically to `itemName`.
    ///
    /// On a future release, this function will be made `private` and ``items`` will autosave inside a `didSet` block.
    ///
    /// *Last updated: July 8, 2022 at 22:16*
    func saveItems() async throws {
        let outfile = try FileManager.default.getURL(for: .items)
        let data = try JSONEncoder().encode(items)
        try data.write(to: outfile, options: .completeFileProtection)
        items.sort {
            $0.itemName < $1.itemName
        }
    }
    
    /// Refreshes ``categories`` with data from device.
    ///
    /// *Last updated: July 8, 2022 at 22:16*
    func loadCategories() async throws {
        let fileURL = try FileManager.default.getURL(for: .categories)
        guard let file = try? FileHandle(forReadingFrom: fileURL) else {
            return
        }
        try withAnimation {
            categories = (try JSONDecoder().decode([String].self, from: file.availableData)).sorted {
                $0 < $1
            }
        }
        
    }
    
    
    /// Saves data stored in ``categories`` to local device.
    ///
    /// There isn't any methods to refresh the list of categores (from ``items``). This is because ``categories``
    /// is only changed inside ``CategoryPickerView``.
    ///
    /// Therefore, as a consequence of ``CategoryPickerView`` appearing as a `sheet`
    /// from ``MenuItemEditorView``, newly added categories are saved to storage before the item itself.
    ///
    /// *Last updated: July 8, 2022 at 22:18*
    func saveCategories() async throws {
        let data = try JSONEncoder().encode(categories)
        let outfile = try FileManager.default.getURL(for: .categories)
        try data.write(to: outfile, options: .completeFileProtection)
        categories.sort {
            $0 < $1
        }
        
    }
    
    func saveIngredient() async throws {
        loadIngredientsFromItems()
        let data = try JSONEncoder().encode(ingredients)
        let outfile = try FileManager.default.getURL(for: .ingredients)
        try data.write(to: outfile, options: .completeFileProtection)
        ingredients.sort {
            $0 < $1
        }
    }
    
    func loadIngredients() async throws {
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
    }
    
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
    
    func saveWarnings() async throws {
        let data = try JSONEncoder().encode(warnings)
        let outfile = try FileManager.default.getURL(for: .warnings)
        try data.write(to: outfile, options: .completeFileProtection)
        warnings.sort {
            $0 < $1
        }
    }
    
    func loadWarnings() async throws {
        let fileURL = try FileManager.default.getURL(for: .warnings)
        guard let file = try? FileHandle(forReadingFrom: fileURL) else {
            return
        }
        try withAnimation {
            warnings = (try JSONDecoder().decode([String].self, from: file.availableData)).sorted {
                $0 < $1
            }
        }
    }
    
    func loadAll() async throws {
        try await loadItems()
        try await loadCategories()
        try await loadIngredients()
        try await loadWarnings()
    }
    
    func saveAll() async throws {
        try await saveItems()
        try await saveCategories()
        try await saveIngredient()
        try await saveWarnings()
    }
    
    static func incrementMenuNumber() async throws -> Int {
        let store = MenuItemStore()
        try await store.loadItems()
        return store.items.count + 1
    }
    
}

enum MenuItemListSortMethod {
    case alphabetical
    case itemNumber
}


fileprivate enum FileURLSaveType: String {
    case item       = "menuItems.data"
    case ingredient = "menuIngredients.data"
    case category   = "menuCategory.data"
    case warnings   = "menuWarnings.data"
}
