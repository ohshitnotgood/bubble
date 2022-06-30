//
//  AddToMenuViewModel.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 30/06/2022.
//

import SwiftUI

class AddToMenuViewModel: ObservableObject {
    enum FocusField: Hashable {
        case itemName
        case regularIngredients
        case extraIngredients
        case `nil`
    }
    
    @FocusState var focusField: FocusField?
    @Published var showCategoryPickerView   = false
    @Published var showWarningsEditor       = false
    @Published var showConfirmationDialog   = false
    @Published var newItem                  = MenuItem()
    
    @EnvironmentObject var menuItemStore: MenuItemStore
    
    init(environmentObject parentEnvironmentObject: EnvironmentObject<MenuItemStore>) {
        self._menuItemStore = parentEnvironmentObject
    }
    
    /// Appends `newItem` to `environmentObject` ``menuItemStore``.
    func saveItemsData() {
        Task {
            if !newItem.itemName.isEmpty {
                withAnimation {
                    menuItemStore.items.append(newItem)
                }
                try await menuItemStore.saveItems()
            }
        }
    }
    
    // MARK: - PurgeExtraList func
    /// Removes all empty strings from `newItem.extraIngredients` list.
    func purgeExtraIngredientsList() {
        withAnimation {
            newItem.extraIngredients.removeAll { ingredient in ingredient == "" }
        }
    }
    
    
    // MARK: - PurgeRegularList func
    /// Removes all empty strings from `newItem.regularIngredients` list.
    func purgeRegularIngredientsList() {
        withAnimation {
            newItem.regularIngredients.removeAll { ingredient in ingredient == "" }
        }
    }
    
    // MARK: - Add new regularm ingr func
    func addNewRegularIngredient() {
        withAnimation {
            purgeExtraIngredientsList()
            if newItem.regularIngredients.count > 0 {
                guard let last = newItem.regularIngredients.last else { return }
                if !last.isEmpty {
                    newItem.regularIngredients.append("")
                    focusField = .regularIngredients
                }
            } else {
                newItem.regularIngredients.append("")
                focusField = .regularIngredients
            }
        }
    }
    
    // MARK: - Add new extra ingr func
    func addNewExtraIngredient() {
        withAnimation {
            purgeRegularIngredientsList()
            if newItem.extraIngredients.count > 0 {
                guard let last = newItem.extraIngredients.last else { return }
                if !last.isEmpty {
                    newItem.extraIngredients.append("")
                    focusField = .extraIngredients
                }
            } else {
                newItem.extraIngredients.append("")
                focusField = .extraIngredients
            }
        }
    }
}
