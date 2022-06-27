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
            if !categories.contains(each_item.category.rawValue) {
                categories.append(each_item.category.rawValue)
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack (spacing: 0) {
                Divider()
                
                SearchField(text: $searchText)
                    .background(
                        VisualEffectView(.systemThinMaterial)
                    )
                
                LazyVStack (spacing: 0, pinnedViews: .sectionHeaders) {
                    ForEach(categories, id: \.self) { category in
                        Section(content: {
                            ForEach(sortedMenu.filter { $0.category.rawValue == category }, id: \.self) { menuItem in
                                ListItem(menuItem)
                                    .id(menuItem)
                            }
                        }, header: { SectionHeader(category) }).id(category)
                    }
                }
            }
        }
    }
}

struct CategoryItemsView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryItemsView()
    }
}
