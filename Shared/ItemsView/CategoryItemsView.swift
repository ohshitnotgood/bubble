//
//  CategoryItemsView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 26/06/2022.
//

import SwiftUI

struct CategoryItemsView: View {
    @State private var searchText = ""
    
    @EnvironmentObject var menuItemStore: MenuItemStore
    @EnvironmentObject var orderStore   : OrderStore
    @EnvironmentObject var settingsStore: SettingsStore
    
    @State private var categories: [String] = []
    
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
    
    private func makeCategoriesList() {
        for each_item in menuItemStore.items {
            if !categories.contains(each_item.category) {
                categories.append(each_item.category)
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(categories, id: \.self) { category in
                Section(content: {
                    ForEach(menuItemStore.items.filter { $0.category == category }, id: \.self) { menuItem in
                        ListItemCellView(menuItem, showItemNumber: settingsStore.data.enableMenuNumbering)
                    }
                }, header: { Text(category) }).id(category)
            }
        }.interactiveDismissDisabled()
            .listStyle(.inset)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), suggestions: {
                if searchText.isNotEmpty {
                    ForEach(searchResults, id: \.self) {
                        ListItemCellView($0)
                    }
                }
            })
            .onAppear(perform: makeCategoriesList)
    }
}

struct CategoryItemsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CategoryItemsView()
                .environmentObject(MenuItemStore())
                .environmentObject(SettingsStore())
                .environmentObject(OrderStore())
        }
    }
}
