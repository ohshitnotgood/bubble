//
//  AddToMenuView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 27/06/2022.
//

import SwiftUI
import Introspect

///
///
/// Upon `.onDisappear()`, if `itemName` is not empty, EnvironmentObject `menuItemStore` is appended with a new `MenuItem`.
struct AddToMenuView: View {
    
    @State private var itemName: String = ""
    @State private var regular: [String] = []
    @State private var extra: [String] = []
    @State private var warnings: [MenuItemWarnings] = [.gluten, .dairy]
    @State private var category: MenuItemCategory = .appetizer
    
    @State private var selectedWarnings: [String] = []
    
    @State private var categories: [String] = ["Main Course", "Appetizer", "Beverage"]
    
    @State private var selection = 0
    
    @EnvironmentObject var menuItemStore: MenuItemStore
    
    func saveData() {
        if !itemName.isEmpty {
            Task {
                menuItemStore.items.append(
                    MenuItem(itemName: itemName, regularIngredients: regular, warnings: warnings, extraIngredients: extra, category: category)
                )
                try await menuItemStore.save()
            }
        }
    }
    
    #warning("Ways to add ingredients.")
    var body: some View {
        List {
            Section {
                TextField("Name", text: $itemName)
                    .introspectTextField { tf in
                        tf.becomeFirstResponder()
                    }
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
                Picker("Category", selection: $selection) {
                    ForEach(Array(zip(categories.indices, categories)), id: \.0) { idx, category in
                        Text(category)
                            .tag(idx)
                    }
                }
                
                NavigationLink(destination: AddCategoryView(categories: $categories)) {
                    Text("Add New Category")
                }
            }, header: {
                Text("Category")
            })
            
        }.navigationTitle("Add Item to Menu")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear(perform: saveData)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveData()
                    }.disabled(itemName.isEmpty)
                }
            }
    }
}

struct AddToMenuView_Previews: PreviewProvider {
    static var previews: some View {
        AddToMenuView()
            .environmentObject(MenuItemStore())
    }
}
