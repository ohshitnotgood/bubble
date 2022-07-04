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
    private var n: Bool
    private var originalName: String = ""
    
    @EnvironmentObject var menuItemStore: MenuItemStore
    
    init() {
        self._newItem = State(initialValue: MenuItem())
        self.n = true
    }
    
    init(menuItem: MenuItem) {
        self._newItem = State(initialValue: menuItem)
        self.n = false
        self.originalName = menuItem.itemName
        print(originalName)
    }
    
    // MARK: - Body
    var body: some View {
        List {
            
            // MARK: itemName
            Section {
                TextField("Name", text: $newItem.itemName)
                    .textInputAutocapitalization(.words)
                    .focused($focusField, equals: .itemName)
                    .submitLabel(.done)
                    .onSubmit { focusField = .regularIngredients }
                    .onChange(of: newItem.itemName, perform: { it in
                        let item_name = it.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                        itemAlreadyExists = menuItemStore.items.contains(where: { item_name == $0.itemName.lowercased() }) && item_name != originalName.lowercased()
                    })
                
            } footer: {
                Text("An item with this name already exists on the menu.")
                    .foregroundColor(.red)
                    .opacity(itemAlreadyExists ? 1 : 0)
            }
            
            // MARK: Regular ingredients
            Section(content: {
                ForEach(newItem.regularIngredients.indices, id: \.self) {
                    TextField("Ingredient Name", text: $newItem.regularIngredients[$0])
                        .focused($focusField, equals: newItem.regularIngredients.last == "" ? .regularIngredients : .nil)
                        .submitLabel(.next)
                        .autocapitalization(.words)
                        .onSubmit(addNewRegularIngredient)
                        .onTapGesture { purgeList() }.deleteDisabled(newItem.regularIngredients[$0] == "")
                }.onDelete { newItem.regularIngredients.remove(atOffsets: $0) }
                
                // MARK: Add regular button
                Button("Add ingredient...", action: addNewRegularIngredient)
                
            }, header: {
                Text("Regular Ingredients")
            })
            
            
            // MARK: Extra ingredients
            Section(content: {
                ForEach(newItem.extraIngredients.indices, id: \.self) {
                    TextField("Ingredient Name", text: $newItem.extraIngredients[$0])
                        .focused($focusField, equals: newItem.extraIngredients.last == "" ? .extraIngredients : .nil)
                        .submitLabel(.next)
                        .autocapitalization(.words)
                        .onSubmit(addNewExtraIngredient)
                        .onTapGesture { purgeList() }
                        .deleteDisabled(newItem.extraIngredients[$0] == "")
                }.onDelete { newItem.extraIngredients.remove(atOffsets: $0) }
                
                // MARK: Add extra button
                Button("Add ingredient...", action: addNewExtraIngredient)
                
            }, header: {
                Text("Extra Ingredients")
            })
            
            // MARK: - Warnings
            Section(content: {
                /**
                 Over here, two separate arrays are being used: one, `menuItemStore.warnings` that is passed from the previous view and the other, `newItem.warnings` that is used to keep track of the items that have been selected.
                 First, the `menuItemStore.warnings` list is looped through to display all possible warnings that the app has stored on device.
                 When the button is clicked, the algorithm checks if the item clicked upon exists in `newItem.warnings`.
                 If it isn't, then the item is added to `newItem.warnings` and a checkmark is displayed.
                 If it is present inside `newItem.warnings`, the item is removed upon click and the checkmark is removed.
                 */
                ForEach(menuItemStore.warnings, id: \.self) { each_warning in
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
                
                // MARK: EditWarnings button
                Button("Edit warnings...") {
                    showWarningsEditor = true
                }
            }, header: {
                Text("Warnings")
            })
            
            
            // MARK: - Category Picker
            Section(content: {
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
            }, header: {
                Text("Category")
            })
            
            // MARK: Delete button
            if !n {
                Button("Delete Item", role: .destructive) {
                    if let index = menuItemStore.items.firstIndex(where: { $0.id == newItem.id }) {
                        menuItemStore.items.remove(at: index)
                    }
                    dismiss()
                }.frame(maxWidth: .infinity)
            }
            
            // MARK: - End Form
        }.navigationTitle(n ? "Add Item to Menu" : "Edit Menu Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    // MARK: Toolbar 'Save' button
                    Button("Save") {
                        showConfirmationDialog = newItem.regularIngredients.isEmpty || newItem.extraIngredients.isEmpty
                        if !showConfirmationDialog {
                            saveItemsData()
                            dismiss()
                        }
                    }.disabled(newItem.itemName.isEmpty || newItem.category.isEmpty || itemAlreadyExists )
                }
            }.sheet(isPresented: $showCategoryPickerView, content: {
                // MARK: CategoryPicker Sheet
                CategoryPickerView(selection: $newItem.category)
                    .environmentObject(menuItemStore)
            })
            .interactiveDismissDisabled()
            .sheet(isPresented: $showWarningsEditor) {
                // MARK: WarningEditor Sheet
                WarningsEditorView().environmentObject(menuItemStore)
                
            }
            .confirmationDialog("Discard Changes", isPresented: $showConfirmationDialog, actions: {
                
                // MARK: Confirmation Dialog
                Button("Keep Editing", role: .cancel) { }
                Button("Save anyway") {
                    saveItemsData()
                    dismiss()
                }
            }, message: {
                Text("You haven't added any ingredients to your list")
            })
    }
    // MARK: - End Body
    
    
    
    // MARK: enum FocusField
    private enum FocusField: Hashable {
        case itemName
        case regularIngredients
        case extraIngredients
        case `nil`
    }
    
    // MARK: - func Save data
    
    /// Appends `newItem` to `environmentObject` ``menuItemStore``.
    private func saveItemsData() {
        purgeList()
        if n {
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
