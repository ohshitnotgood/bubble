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
    
    @State private var itemName: String = ""
    @State private var regular: [String] = []
    @State private var extra: [String] = []
    @State private var warnings: [MenuWarnings] = [.gluten, .dairy]
    
    @State private var selectedWarnings: [String] = []
    
    @State private var selectedCategory = ""
    @State private var showCategoryPickerView = false
    
    @EnvironmentObject var menuItemStore: MenuItemStore
    
    /// Creates new `MenuItem` object and adds to `environmentObject`.
    func saveItemsData() {
        Task {
            if !itemName.isEmpty {
                withAnimation {
                    menuItemStore.items.append(
                        MenuItem(itemName: itemName, regularIngredients: regular, warnings: warnings, extraIngredients: extra, category: selectedCategory)
                    )
                }
                try await menuItemStore.saveItems()
            }
        }
    }
    
#warning("Ways to add ingredients.")
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $itemName)
            }
            
            Section(content: {
                ForEach(regular, id: \.self) { each_ingredrient in
                    
                }
                
                Button("Add custom ingredient...") {
                    
                }
            }, header: {
                Text("Regular Ingredients")
            })
            
            Section(content: {
                Button("Add custom ingredient...") {
                    
                }
            }, header: {
                Text("Extra Ingredients")
            })
            
            Section(content: {
                /**
                 Over here, two separate arrays are being used: one, `warnings` that is passed from the previous view and the other, `selectedWarnings` that is used to keep track of the items that have been selected.
                 First, the `warnings` list is looped through to display all possible warnings that the app has stored on device.
                 When the button is clicked, the algorithm checks if the item clicked upon exists in `selectedWarnings`.
                 If it isn't, then the item is added to `selectedWarnings` and a checkmark is displayed.
                 If it is present inside `selectedWarnings`, the item is removed upon click and the checkmark is removed.
                 */
                ForEach(warnings, id: \.self) { each_warning in
                    Button (action: {
                        if selectedWarnings.contains(each_warning.rawValue) {
                            if let index = selectedWarnings.firstIndex(of: each_warning.rawValue) {
                                selectedWarnings.remove(at: index)
                            }
                        } else {
                            selectedWarnings.append(each_warning.rawValue)
                        }
                    }) {
                        HStack {
                            Text(each_warning.rawValue.capitalized)
                                .foregroundColor(.sensiBlack)
                            
                            Spacer()
                            
                            Image(systemName: "checkmark")
                                .padding(.trailing, 5)
                                .opacity(selectedWarnings.contains(each_warning.rawValue) ? 1 : 0)
                        }
                    }
                }
                
#warning("Add custom warning")
                Button("Add custom warning...") {
                    
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
                        Text(selectedCategory)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                }
                
                //                // Show CategoryPicker only after one or more categories have been added.
                //                if menuItemStore.categories.count > 0 {
                //                    HStack {
                //                        Text("Category")
                //                            .foregroundColor(.sensiBlack)
                //
                //                        Spacer()
                //
                //                        Picker("Category", selection: $selectedCategory) {
                //                            ForEach(menuItemStore.categories.sorted { $0 < $1 }, id: \.self) { each_category in
                //                                Text(each_category)
                //                                    .tag(each_category)
                //                            }
                //                        }.pickerStyle(.menu)
                //                    }
                //                }
                //
                //                NavigationLink(destination: CategoryEditorView().environmentObject(menuItemStore)) {
                //                    Text("Edit categories")
                //                }
                
            }, header: {
                Text("Category")
            })
            
        }.navigationTitle("Add Item to Menu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveItemsData()
                        dismiss()
                    }.disabled(itemName.isEmpty)
                }
            }.sheet(isPresented: $showCategoryPickerView, content: {
                CategoryPickerView(selection: $selectedCategory)
                    .environmentObject(menuItemStore)
            }).interactiveDismissDisabled()
    }
}

struct AddToMenuView_Previews: PreviewProvider {
    static var previews: some View {
        AddToMenuView()
            .environmentObject(MenuItemStore())
    }
}
