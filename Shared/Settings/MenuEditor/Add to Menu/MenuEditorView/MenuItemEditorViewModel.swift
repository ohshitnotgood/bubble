//
//  MenuItemEditorViewModel.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 7/07/2022.
//

import SwiftUI

class MenuItemEditorViewModel: ObservableObject {
    @Published var showCategoryPickerView   = false
    @Published var showWarningEditor        = false
    @Published var showConfirmationDialog   = false
    @Published var showRegularsPicker       = false
    @Published var showExtrasPicker         = false
    
    @Published var itemAlreadyExists        = false
    
    @Published var newItem                  : MenuItem
    
    var item_editing_mode                   = false
    var original_name                       = ""
    
    init(inEditMode menuItem: MenuItem) {
        self.newItem = menuItem
        
        self.item_editing_mode = true
        self.original_name = menuItem.itemName
    }
    
    init() {
        self.newItem = MenuItem()
    }
    
    /// Checks if an item with a similar name has already been saved in the menu.
    ///
    /// Items with duplicate names are not allowed on the list.
    /// - Parameter in : list where duplicates are searched for.
    func checkItemExist(in list: [MenuItem]) {
        itemAlreadyExists = list.contains(where: {
            newItem.itemName.lowercased() == $0.itemName.lowercased()
        }) && newItem.itemName.lowercased() != original_name.lowercased()
    }
    
    func updateConfirmationDialogFlag() {
        showConfirmationDialog = newItem.regularIngredients.count <= 0
    }
    
    func setItemNumber(_ number: Int) {
        if !item_editing_mode {
            self.newItem.itemNumber = number
        }
    }
}
