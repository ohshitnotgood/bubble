//
//  AddToMenuView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 27/06/2022.
//

import SwiftUI

struct AddToMenuView: View {
    
    @State private var itemName: String = ""
    @State private var regular: [String] = []
    @State private var extra: [String] = []
    @State private var warnings: [MenuItemWarnings] = []
    @State private var category: MenuItemCategory = .appetizer
    
    @State private var selection = 0
    
    @EnvironmentObject var menuItemStore: MenuItemStore
    
    var body: some View {
        List {
            Section (content: {
                TextField("Name", text: $itemName)
            }, header: {
                
            })
            
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
                Button (action: {}) {
                    HStack {
                        Image(systemName: "checkmark")
                            .padding(.trailing, 5)
                        
                        Text("Dairy")
                    }
                }.buttonStyle(.plain)
                
                HStack {
                    Image(systemName: "checkmark")
                        .padding(.trailing, 5)
                    Text("Gluten")
                }
                
                Button("Add custom warning...") {
                    
                }
            }, header: {
                Text("Warnings")
            })
            
            Section(content: {
                Picker("Category", selection: $selection) {
                    Text(MenuItemCategory.appetizer.rawValue)
                        .tag(0)
                        .foregroundColor(.sensiBlack)
                    
                    Text(MenuItemCategory.mainCourse.rawValue)
                        .tag(1)
                        .foregroundColor(.sensiBlack)
                    
                    Text(MenuItemCategory.beverage.rawValue)
                        .tag(2)
                        .foregroundColor(.sensiBlack)
                    
                }
                
                #warning("Add view to add new category")
                Button("Add New Category") {
                    
                }
            }, header: {
                Text("Category")
            })
            
        }.navigationTitle("Add Item to Menu")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                Task {
                    menuItemStore.items.append(
                        MenuItem(itemName: itemName, regularIngredients: regular, warnings: warnings, extraIngredients: extra, category: category)
                    )
                    try await menuItemStore.save()
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
