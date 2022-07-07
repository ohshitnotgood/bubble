//
//  MenuItemEditorView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 7/07/2022.
//

import SwiftUI

struct MenuItemEditorView: View {
    @EnvironmentObject var menuItemStore: MenuItemStore
    @ObservedObject private var vm: MenuItemEditorViewModel
    @Environment(\.dismiss) private var dismiss
    
    init() {
        self.vm = MenuItemEditorViewModel()
    }
    
    init(inEditMode menuItem: MenuItem) {
        self.vm = MenuItemEditorViewModel(inEditMode: menuItem)
    }
    
    func saveData() async throws {
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
//                    .introspectTextField { tf in
//                        tf.becomeFirstResponder()
//                    }
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
                        
                    } label: {
                        // MARK: Warning label
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
                            .foregroundColor(.gray)
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
            
            
        }.navigationTitle(vm.item_editing_mode ? "Edit Menu Item Editor" : "Add a Menu Item Editor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { Task {
                        vm.updateConfirmationDialogFlag()
                        try await saveData()
                        dismiss()
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
            .confirmationDialog("", isPresented: $vm.showConfirmationDialog, actions: {
                Button("Keep Editing", role: .cancel) {
                }
                
                Button("Save Anyway") { Task {
                    try await saveData()
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
    }
}
