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
                        ListItem(menuItem)
                            .id(menuItem)
                    }
                }, header: { Text(category) }).id(category)
            }
        }.interactiveDismissDisabled()
            .listStyle(.inset)
            .searchable(text: $searchText)
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
