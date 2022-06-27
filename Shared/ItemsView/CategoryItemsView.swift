//
//  CategoryItemsView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 26/06/2022.
//

import SwiftUI

struct CategoryItemsView: View {
    @State private var searchText = ""
    
    var categories: [String] = []
    
    let sortedMenu = menuItems.sorted {
        $0.itemName < $1.itemName
    }
    
    init() {
        for each_item in sortedMenu {
            if !categories.contains(each_item.category) {
                categories.append(each_item.category)
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(categories, id: \.self) { category in
                Section(content: {
                    ForEach(sortedMenu.filter { $0.category == category }, id: \.self) { menuItem in
                        ListItem(menuItem)
                            .id(menuItem)
                    }
                }, header: { SectionHeader(category) }).id(category)
            }
        }.interactiveDismissDisabled()
            .listStyle(.grouped)
    }
}

struct CategoryItemsView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryItemsView()
    }
}
