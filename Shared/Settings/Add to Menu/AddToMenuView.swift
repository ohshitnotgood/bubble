//
//  AddToMenuView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 27/06/2022.
//

import SwiftUI
import Introspect

/// Adds and saves a new `MenuItem` to `MenuItemStore`.
///
///`[SettingsView] -> [MenuEditorView] -> [AddToMenuView]` to add and edit items in to the menu.
///
/// Upon `.onDisappear()`, if `itemName` is not empty, EnvironmentObject `menuItemStore` is appended with a new `MenuItem`.
struct AddToMenuView: View {
    @Environment(\.dismiss) private var dismiss
    
    private enum FocusField: Hashable {
        case itemName
        case regularIngredients
        case extraIngredients
        case `nil`
    }
    
    @FocusState private var focusField: FocusField?
    @State private var showCategoryPickerView   = false
    @State private var showWarningsEditor       = false
    @State private var showConfirmationDialog   = false
    
    @State private var newItem = MenuItem()
    
    @EnvironmentObject var menuItemStore: MenuItemStore
    
    /// Creates new `MenuItem` object and adds to `environmentObject`.
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
    
    func purgeExtraIngredientsList() {
        withAnimation {
            newItem.extraIngredients.removeAll { ingredient in ingredient == "" }
        }
    }
    
    func purgeRegularIngredientsList() {
        withAnimation {
            newItem.regularIngredients.removeAll { ingredient in ingredient == "" }
        }
    }
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
    
    
    var body: some View {
        Form {
            // MARK: itemName
            Section {
                TextField("Name", text: $newItem.itemName)
                    .textInputAutocapitalization(.words)
                    .submitLabel(.done)
                    .onSubmit { focusField = nil }
            }
            
            // MARK: Regular ingredients
            Section(content: {
                ForEach(newItem.regularIngredients.indices, id: \.self) {
                    TextField("Ingredient Name", text: $newItem.regularIngredients[$0])
                        .focused($focusField, equals: newItem.regularIngredients.last == "" ? .regularIngredients : .nil)
                        .submitLabel(.next)
                        .onSubmit(addNewRegularIngredient)
                        .onTapGesture {
                            purgeExtraIngredientsList()
                        }
                }
                
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
                        .onSubmit(addNewExtraIngredient)
                        .onTapGesture {
                            purgeRegularIngredientsList()
                        }
                    
                }
                
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
                
                Button("Edit warnings...") {
                    showWarningsEditor = true
                }
            }, header: {
                Text("Warnings")
            })
            
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
            
        }.navigationTitle("Add Item to Menu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        showConfirmationDialog = newItem.regularIngredients.isEmpty || newItem.extraIngredients.isEmpty
                        if !showConfirmationDialog {
                            saveItemsData()
                            dismiss()
                        }
                    }.disabled(newItem.itemName.isEmpty || newItem.category.isEmpty)
                }
            }.sheet(isPresented: $showCategoryPickerView, content: {
                CategoryPickerView(selection: $newItem.category)
                    .environmentObject(menuItemStore)
            }).interactiveDismissDisabled()
            .sheet(isPresented: $showWarningsEditor) {
                WarningsEditorView().environmentObject(menuItemStore)
            }.confirmationDialog("Discard Changes", isPresented: $showConfirmationDialog, actions: {
                Button("Keep Editing", role: .cancel) { }
                Button("Save anyway") {
                    saveItemsData()
                    dismiss()
                }
            }, message: {
                Text("You haven't added any ingredients to your list")
            })
    }
}

struct AddToMenuView_Previews: PreviewProvider {
    static var previews: some View {
        AddToMenuView()
            .environmentObject(MenuItemStore())
    }
}
