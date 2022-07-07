//
//  MenuEditorView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 27/06/2022.
//

import SwiftUI
import Introspect

/// Displays text fields and toggles to edit an item in the menu.
///
///
@available(*, renamed: "MenuItemEditorView()")
struct MenuEditorView: View {
    @Environment(\.dismiss) private var dismiss
    
    @FocusState private var focusField: FocusField?
    @State private var showCategoryPickerView   = false
    @State private var showWarningsEditor       = false
    @State private var showConfirmationDialog   = false
    @State private var itemAlreadyExists        = false
    @State private var showRegularPicker        = false
    @State private var showExtraPicker          = false
    
    @State private var newItem: MenuItem
    private var item_editing_mode: Bool
    private var original_name: String = ""
    
    
    /// `EnvironmentObject` that contains information about items and ingredients on the menu.
    @EnvironmentObject var menuItemStore: MenuItemStore
    
    init() {
        self._newItem = State(initialValue: MenuItem())
        self.item_editing_mode = false
    }
    
    init(menuItem: MenuItem) {
        self._newItem = State(initialValue: menuItem)
        self.item_editing_mode = true
        self.original_name = menuItem.itemName
        print(original_name)
    }
    
    // MARK: - Begin ViewBuilders
    
    /// **Save button** that is displayed in the toolbar.
    @ViewBuilder private func save_button() -> some View {
        Button("Save") {
            showConfirmationDialog = newItem.regularIngredients.isEmpty || newItem.extraIngredients.isEmpty
            if !showConfirmationDialog {
                saveItemsData()
                dismiss()
            }
        }.disabled(newItem.itemName.isEmpty || newItem.category.isEmpty || itemAlreadyExists )
    }
    
    @ViewBuilder func warning_selector_label(label each_warning: String) -> some View {
        Button (action: {
            newItem.warnings.removeIfContainsElseAppend(each_warning)
        }) {
            // MARK: Warning selectors
            HStack {
                Text(each_warning.capitalized)
                    .foregroundColor(.sensiBlack)
                
                Spacer()
                
                Image(systemName: "checkmark")
                    .padding(.trailing, 5)
                    .opacity(newItem.warnings.contains(each_warning) ? 1 : 0)
            }
        }
    }
    
    
    // MARK: ItemName section
    @ViewBuilder func section_itemName() -> some View {
        Section {
            TextField("Name", text: $newItem.itemName)
                .textInputAutocapitalization(.words)
                .focused($focusField, equals: .itemName)
                .submitLabel(.done)
                .onSubmit(addNewRegularIngredient)
                .onChange(of: newItem.itemName, perform: { it in
                    let item_name = it.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                    itemAlreadyExists = menuItemStore.items.contains(where: { item_name == $0.itemName.lowercased() }) && item_name != original_name.lowercased()
                })
            
        } footer: {
            Text("An item with this name already exists on the menu.")
                .foregroundColor(.red)
                .opacity(itemAlreadyExists ? 1 : 0)
        }
    }
    
    
    // MARK: regular section
    @ViewBuilder func section_regularIngredients() -> some View {
        Section(content: {
//            ForEach(newItem.regularIngredients.indices, id: \.self) {
//                text_field($newItem.regularIngredients[$0])
//                    .focused($focusField, equals: newItem.regularIngredients.last == "" ? .regularIngredients : .nil)
//                    .onTapGesture { purgeList() }
//                    .onSubmit(addNewRegularIngredient)
//
//            }.onDelete { newItem.regularIngredients.remove(atOffsets: $0) }
//
//            Button("Add ingredient...", action: addNewRegularIngredient)
            
            ForEach(newItem.regularIngredients, id: \.self) {
                Text($0)
            }
            
            Button("Edit ingredients...") {
                showRegularPicker = true
            }
            
        }, header: {
            Text("Regular Ingredients")
        })
    }
    
    // MARK: extra section
    @ViewBuilder func section_extraIngredients() -> some View {
        Section(content: {
//            ForEach(newItem.extraIngredients.indices, id: \.self) {
//
//                text_field($newItem.extraIngredients[$0])
//                    .focused($focusField, equals: newItem.extraIngredients.last == "" ? .extraIngredients : .nil)
//                    .onTapGesture { purgeList() }
//                    .onSubmit(addNewExtraIngredient)
//
//            }.onDelete { newItem.extraIngredients.remove(atOffsets: $0) }
//
//            Button("Add ingredient...", action: addNewExtraIngredient)
            
            ForEach(newItem.extraIngredients, id: \.self) {
                Text($0)
            }
            
            Button("Edit ingredients...") {
                showExtraPicker = true
            }
            
        }, header: {
            Text("Extra Ingredients")
        })
    }
    
    
    // MARK: Warnings
    @ViewBuilder func section_warnings() -> some View {
        Section(content: {
            ForEach(menuItemStore.warnings, id: \.self) { each_warning in
                warning_selector_label(label: each_warning)
            }
            
            Button("Edit warnings...") {
                showWarningsEditor = true
            }
        }, header: {
            Text("Warnings")
        })
    }
    
    
    // MARK: CategoryPicker
    @ViewBuilder func section_categoryPicker() -> some View {
        Section(content: {
            categoryPickerButton(newItem.category) {
                showCategoryPickerView = true
            }
        }, header: {
            Text("Category")
        })
    }
    
    // MARK: Delete button
    @ViewBuilder func section_deleteButton() -> some View {
        // MARK: - Delete button
        Section {
            deleteButton(isVisible: item_editing_mode) {
                if let index = menuItemStore.items.firstIndex(where: { $0.id == newItem.id }) {
                    menuItemStore.items.remove(at: index)
                }
                dismiss()
            }
        }
    }
    
    
    // MARK: - End ViewBuilders
    
    
    
    // MARK: - func Save data
    
    /// Appends `newItem` to `environmentObject` ``menuItemStore``.
    ///
    /// Checks if a new item is being entered and appropriately adds or replaces the item in ``menuItemStore``.
    private func saveItemsData() {
        purgeList()
        if !item_editing_mode {
            menuItemStore.items.append(newItem)
        } else if let index = menuItemStore.items.firstIndex(where: { $0.id == newItem.id }) {
            menuItemStore.items.remove(at: index)
            menuItemStore.items.insert(newItem, at: index)
        }
        
        
        Task { try await menuItemStore.saveItems() }
    }
    
    // MARK: - func PurgeList
    /// Removes duplicates and empty strings from regular and extras lists.
    private func purgeList() {
        withAnimation {
            newItem.regularIngredients.removeAll { $0 == "" }
            newItem.extraIngredients.removeAll { $0 == "" }
            
            newItem.regularIngredients.removeDuplicates()
            newItem.extraIngredients.removeDuplicates()
            
            newItem.regularIngredients.stripAll()
            newItem.extraIngredients.stripAll()
        }
    }
    
    // MARK: - func Add new regular ingr
    private func addNewRegularIngredient() {
        withAnimation {
            purgeList()
            newItem.regularIngredients.append("")
            focusField = .regularIngredients
        }
    }
    
    // MARK: - func Add new extra ingr
    private func addNewExtraIngredient() {
        withAnimation {
            purgeList()
            newItem.extraIngredients.append("")
            focusField = .extraIngredients
        }
    }
    
    
    
    // MARK: - Body
    var body: some View {
        List {
            section_itemName()
            section_regularIngredients()
            section_extraIngredients()
            section_warnings()
            section_categoryPicker()
            section_deleteButton()
        }.navigationTitle(item_editing_mode ? "Edit Menu Item" : "Add Item to Menu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .confirmationAction) { save_button() } }
            .sheet(isPresented: $showCategoryPickerView, content: { CategoryPickerView(selection: $newItem.category).environmentObject(menuItemStore)})
            .interactiveDismissDisabled()
            .sheet(isPresented: $showWarningsEditor) { WarningsEditorView().environmentObject(menuItemStore) }
            .sheet(isPresented: $showRegularPicker, content: {
                IngredientSelector(saveSelectedIngredientsIn: $newItem.regularIngredients, loadSavedIngredientsFrom: menuItemStore.ingredients)
            })
            .sheet(isPresented: $showExtraPicker, content: {
                IngredientSelector(saveSelectedIngredientsIn: $newItem.extraIngredients, loadSavedIngredientsFrom: menuItemStore.ingredients)
            })
            .confirmationDialog("Discard Changes", isPresented: $showConfirmationDialog, actions: {
                confirmationDialogButtons {
                    saveItemsData()
                    dismiss()
                }
            }, message: {
                Text("You haven't added any ingredients to your list")
            })
    }
}



#if DEBUG
struct AddToMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MenuEditorView(menuItem: MenuItem.pizza)
                .environmentObject(MenuItemStore())
        }
    }
}
#endif
