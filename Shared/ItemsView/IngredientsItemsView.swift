//
//  IngredientsItemsView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 26/06/2022.
//

import SwiftUI

struct IngredientsItemsView: View {
    @State var searchText = ""
    
    @EnvironmentObject var menuItemStore: MenuItemStore
    @EnvironmentObject var orderStore   : OrderStore
    @EnvironmentObject var settingsStore: SettingsStore
    
    @State private var ingredients: [String] = []
    
    private func makeIngredientsList() {
        menuItemStore.items.forEach { each_item in
            each_item.regularIngredients.forEach { each_ingredient in
                if !ingredients.contains(each_ingredient) {
                    ingredients.append(each_ingredient)
                }
            }
        }
        ingredients.sort()
    }
    
    var body: some View {
        List {
            ForEach(ingredients, id: \.self) { each_ingredient in
                Section {
                    ForEach(menuItemStore.items, id: \.self) { menu_item in
                        if menu_item.regularIngredients.contains(each_ingredient) {
                            ListItemCellView(menu_item)
                        }
                    }
                } header: {
                    Text(each_ingredient)
                }

            }
        }.listStyle(.inset)
            .searchable(text: $searchText)
            .onAppear(perform: makeIngredientsList)
    }
}

struct IngredientsItemsView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientsItemsView()
            .environmentObject(MenuItemStore())
            .environmentObject(SettingsStore())
            .environmentObject(OrderStore())
    }
}
