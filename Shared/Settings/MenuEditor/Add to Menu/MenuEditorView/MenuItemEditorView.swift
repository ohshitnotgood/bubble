//
//  MenuItemEditorView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 7/07/2022.
//

import SwiftUI

/// View that allows users to add a new or edit an existing item on the menu.
///
/// There are `NavigationLinks` to the following views:
///
/// - ``IngredientSelector``: when the user clicks on **Edit Ingredients...** adding/editing regular and extra ingredients.
///
/// - ``CategoryPickerView``: for picking a category
///
/// - ``WarningsEditorView``: for editing warnings
///
///
/// This view references ``MenuItemEditorViewModel`` to store state information.
///
/// Item is only added to/saved in the menu when the **Save** button is clicked from the toolbar which calls ``saveData()`` function.
///
/// A `confirmationDialog` is shown if no **regular ingredients** has been added which then allows the user to *keep editing* or
/// *save anyway*.
///
/// There isn't a `WarningPickerView` since **warnings are selected directly in this view**. Only the ingredients and the category
/// are picked in separate `sheet`s.
///
/// *Last updated on June 8, 2022 at 22:40*
struct MenuItemEditorView: View {
    @EnvironmentObject var menuItemStore: MenuItemStore
    @EnvironmentObject var settingsStore: SettingsStore
    
    @StateObject private var vm: MenuItemEditorViewModel
    @Environment(\.dismiss) private var dismiss
    
    /// Initialises in creating mode.
    init() {
        _vm = StateObject(wrappedValue: MenuItemEditorViewModel())
    }
    
    
    /// Initialises in editing mode.
    init(inEditMode menuItem: MenuItem) {
        _vm = StateObject(wrappedValue: MenuItemEditorViewModel(inEditMode: menuItem))
    }
    
    func saveData() {
        if vm.item_editing_mode {
            if let index = menuItemStore.items.firstIndex(where: { $0.id == vm.newItem.id }) {
                menuItemStore.items.remove(at: index)
                menuItemStore.items.append(vm.newItem)
            }
        } else {
            menuItemStore.items.append(vm.newItem)
        }
        Task {
            try await menuItemStore.saveItems()
        }
    }
    
    var body: some View {
        List {
            // MARK: ItemName
            Section {
                TextField("Name", text: $vm.newItem.itemName)
                    .textInputAutocapitalization(.words)
                    .onChange(of: vm.newItem.itemName, perform: { _ in
                        vm.checkItemExist(in: menuItemStore.items)
                    })
                if settingsStore.data.enableMenuNumbering {
                    HStack {
                        Text("Item number")
                            .foregroundStyle(.secondary)
                        Divider()
                        TextField("Item number", value: $vm.newItem.itemNumber, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                    }
                }
            } header: {
                Text("Item name")
            } footer: {
                Text("An item with this name already exists on the menu.")
                    .foregroundColor(.red)
                    .opacity(vm.itemAlreadyExists ? 1 : 0)
            }
            
            // MARK: Regular section
            Section {
                ForEach(vm.newItem.regularIngredients, id: \.self) {
                    Text($0)
                }
                
                Button("Edit ingredients...") {
                    vm.showRegularsPicker = true
                }
            } header: {
                Text("Regular Ingredients")
            }
            
            // MARK: Extra section
            Section {
                ForEach(vm.newItem.extraIngredients, id: \.self) {
                    Text($0)
                }
                
                Button("Edit ingredients...") {
                    vm.showExtrasPicker = true
                }
            } header: {
                Text("Extra Ingredients")
            }
            
            // MARK: Warnings
            Section {
                ForEach(menuItemStore.warnings, id: \.self) { each_w in
                    Button {
                        vm.newItem.warnings.removeIfContainsElseAppend(each_w)
                    } label: {
                        HStack {
                            Text(each_w.capitalized)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Image(systemName: "checkmark")
                                .padding(.trailing, 5)
                                .opacity(vm.newItem.warnings.contains(each_w) ? 1 : 0)
                        }
                    }
                }
                
                Button("Edit warnings...") {
                    vm.showWarningEditor = true
                }
            } header: {
                Text("Warnings")
            }
            
            
            // MARK: Categories
            Section {
                Button {
                    vm.showCategoryPickerView = true
                } label: {
                    HStack {
                        Text("Category")
                            .foregroundColor(.primary)
                        Spacer()
                        Text(vm.newItem.category)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }
            }
            
            // MARK: Delete button
            Section {
                if vm.item_editing_mode {
                    Button("Delete", role: .destructive) {
                        if let index = menuItemStore.items.firstIndex(where: { $0.id == vm.newItem.id
                        }) {
                            menuItemStore.items.remove(at: index)
                            Task {
                                try await menuItemStore.saveItems()
                            }
                        }
                        dismiss()
                    }.frame(maxWidth: .infinity)
                }
            }
            
            
        }.navigationTitle(vm.item_editing_mode ? "Edit Menu Item" : "Add a Menu Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    // MARK: Save Button
                    Button("Save") { Task {
                        vm.updateConfirmationDialogFlag()
                        if !vm.showConfirmationDialog {
                            saveData()
                            dismiss()
                        }
                    }}.disabled(vm.newItem.itemName.isEmpty || vm.newItem.category.isEmpty || vm.itemAlreadyExists)
                }
            }
            .sheet(isPresented: $vm.showRegularsPicker, content: {
                IngredientSelector(saveSelectedIngredientsIn: $vm.newItem.regularIngredients, loadSavedIngredientsFrom: menuItemStore.ingredients)
            })
            .sheet(isPresented: $vm.showExtrasPicker) {
                IngredientSelector(saveSelectedIngredientsIn: $vm.newItem.extraIngredients, loadSavedIngredientsFrom: menuItemStore.ingredients)
            }
            .sheet(isPresented: $vm.showWarningEditor) {
                WarningsEditorView()
                    .environmentObject(menuItemStore)
            }
            .sheet(isPresented: $vm.showCategoryPickerView) {
                CategoryPickerView(selection: $vm.newItem.category)
                    .environmentObject(menuItemStore)
            }
            .onAppear {
                vm.setItemNumber(menuItemStore.largestItemNumber + 1)
            }
            .confirmationDialog("", isPresented: $vm.showConfirmationDialog, actions: {
                Button("Keep Editing", role: .cancel) {
                }
                
                Button("Save Anyway") { Task {
                    saveData()
                    dismiss()
                }}
            }, message: {
                Text("Are you sure you want to save this item without any ingredients?")
            })
    }
}

struct MenuItemEditorView_Previews: PreviewProvider {
    static var previews: some View {
        MenuItemEditorView()
            .environmentObject(MenuItemStore())
            .environmentObject(SettingsStore())
    }
}
