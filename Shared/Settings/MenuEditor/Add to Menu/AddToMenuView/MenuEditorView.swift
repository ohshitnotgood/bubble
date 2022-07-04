//
//  MenuEditorView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 27/06/2022.
//

import SwiftUI
import Introspect

/// Allows users to save a new menu item or edit an already existing one.
///
///**Bugs List:**
/// 
struct MenuEditorView: View {
    @Environment(\.dismiss) private var dismiss
    
    @FocusState private var focusField: FocusField?
    @State private var showCategoryPickerView   = false
    @State private var showWarningsEditor       = false
    @State private var showConfirmationDialog   = false
    @State private var itemAlreadyExists        = false
    
    @State private var newItem: MenuItem
    private var item_editing_mode: Bool
    private var original_name: String = ""
    
    /// `EnvironmentObject` that contains information about items and ingredients on the menu.
    @EnvironmentObject var menuItemStore: MenuItemStore
    
    init() {
        self._newItem = State(initialValue: MenuItem())
        self.item_editing_mode = true
    }
    
    init(menuItem: MenuItem) {
        self._newItem = State(initialValue: menuItem)
        self.item_editing_mode = false
        self.original_name = menuItem.itemName
        print(original_name)
    }
    
    var body: some View {
        // MARK: - List
        List {
            Section {
                
                // MARK: itemName
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
            
            // MARK: Regular ingredients
            Section(content: {
                ForEach(newItem.regularIngredients.indices, id: \.self) {
                    
                    text_field($newItem.regularIngredients[$0])
                        .focused($focusField, equals: newItem.regularIngredients.last == "" ? .regularIngredients : .nil)
                        .onSubmit(addNewRegularIngredient)
                    
                }.onDelete { newItem.regularIngredients.remove(atOffsets: $0) }
                
                Button("Add ingredient...", action: addNewRegularIngredient)
                
            }, header: {
                Text("Regular Ingredients")
            })
            
            
            // MARK: Extra ingredients
            Section(content: {
                ForEach(newItem.extraIngredients.indices, id: \.self) {
                    
                    text_field($newItem.extraIngredients[$0])
                        .focused($focusField, equals: newItem.extraIngredients.last == "" ? .extraIngredients : .nil)
                        .onSubmit(addNewExtraIngredient)
                    
                }.onDelete { newItem.extraIngredients.remove(atOffsets: $0) }
                
                Button("Add ingredient...", action: addNewExtraIngredient)
                
            }, header: {
                Text("Extra Ingredients")
            })
            
            // MARK: - Warnings
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
            
            
            // MARK: - Category Picker
            Section(content: {
                category_picker_label()
            }, header: {
                Text("Category")
            })
            
            
            // MARK: - Delete button
            Section {
                delete_button()
            }
            
            // MARK: - End List
        }.navigationTitle(item_editing_mode ? "Add Item to Menu" : "Edit Menu Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .confirmationAction) { save_button() } }
            .sheet(isPresented: $showCategoryPickerView, content: { CategoryPickerView(selection: $newItem.category).environmentObject(menuItemStore)})
            .interactiveDismissDisabled()
            .sheet(isPresented: $showWarningsEditor) { WarningsEditorView().environmentObject(menuItemStore) }
            .confirmationDialog("Discard Changes", isPresented: $showConfirmationDialog, actions: {
                confirmation_dialog_actions()
            }, message: {
                Text("You haven't added any ingredients to your list")
            })
    }
    
    
    
    // MARK: - ViewBuilders
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
    
    /// **Delete Button** that deletes item in editing more from ``menuItemStore`` that is displayed at the end of the form only in editing mode.
    ///
    /// Checks if current view is in editing more before appearing in the form.
    @ViewBuilder private func delete_button() -> some View {
        if !item_editing_mode {
            Button("Delete Item", role: .destructive) {
                if let index = menuItemStore.items.firstIndex(where: { $0.id == newItem.id }) {
                    menuItemStore.items.remove(at: index)
                }
                dismiss()
            }.frame(maxWidth: .infinity)
        }
    }
    
    /// **TextField** where the user can edit or enter new ingredients.
    @ViewBuilder func text_field(_ text: Binding<String>) -> some View {
        TextField("Ingredient Name", text: text)
            .submitLabel(.next)
            .autocapitalization(.words)
            .onTapGesture { purgeList() }
            .deleteDisabled(text.wrappedValue == "")
    }
    
    /// Clickable label that opens `sheet`to view `CategoryPickerView`.
    @ViewBuilder func category_picker_label() -> some View {
        Button {
            showCategoryPickerView = true
        } label: {
            HStack {
                Text("Category")
                    .foregroundColor(.sensiBlack)
                Spacer()
                Text(newItem.category)
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
        }
        
    }
    
    /// Confirmation dialog actions.
    ///
    /// Actions:
    /// - **Keep Editing**
    /// - **Save Anyway**
    @ViewBuilder func confirmation_dialog_actions() -> some View {
        Button("Keep Editing", role: .cancel) { }
        Button("Save anyway") {
            saveItemsData()
            dismiss()
        }
    }
    
    /**
     Clickable label for displaying warnings.
     
     Ttwo separate arrays are being used:
     - `menuItemStore.warnings` that stores all previously added warnings.
     - `newItem.warnings` that is used to keep track of selected warnings.
     
     A loop runs through `menuItemStore.warnings` to display all previously saved warnings.
     
     Upon click on `newItem.warnings`, if clicked warning label is contained in `newItem.warnings` it is removed.
     Else the warning is added into the list.
     */
    
    @ViewBuilder func warning_selector_label(label each_warning: String) -> some View {
        Button (action: {
            if newItem.warnings.contains(each_warning) {
                if let index = newItem.warnings.firstIndex(of: each_warning) {
                    newItem.warnings.remove(at: index)
                }
            } else {
                newItem.warnings.append(each_warning)
            }
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
    
    
    // MARK: enum FocusField
    private enum FocusField: Hashable {
        case itemName
        case regularIngredients
        case extraIngredients
        case `nil`
    }
    
    // MARK: - func Save data
    
    /// Appends `newItem` to `environmentObject` ``menuItemStore``.
    ///
    /// Checks if a new item is being entered and appropriately adds or replaces the item in ``menuItemStore``.
    private func saveItemsData() {
        purgeList()
        if item_editing_mode {
            menuItemStore.items.append(newItem)
        } else if let index = menuItemStore.items.firstIndex(where: { $0.id == newItem.id }) {
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
}



#if DEBUG
struct AddToMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MenuEditorView(menuItem: menuItems[1])
                .environmentObject(MenuItemStore())
        }
    }
}
#endif
