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
    
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = true
    }
    
    var searchResults: [MenuItem] {
        if searchText.isEmpty {
            return menuItemStore.items
        } else {
            return menuItemStore.items.filter {
                $0.itemName.localizedCaseInsensitiveContains(searchText) || $0.regularIngredients.contains(where: {
                    $0.localizedCaseInsensitiveContains(searchText)
                }) || $0.extraIngredients.contains(where: {
                    $0.localizedCaseInsensitiveContains(searchText)
                }) || String($0.itemNumber).localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
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
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), suggestions: {
                if searchText.isNotEmpty {
                    ForEach(searchResults, id: \.self) {
                        ListItemCellView($0)
                    }
                }
            })
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
