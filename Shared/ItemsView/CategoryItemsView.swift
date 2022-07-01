//
//  CategoryItemsView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 26/06/2022.
//

import SwiftUI

struct CategoryItemsView: View {
    @State private var searchText = ""
    
    var selection: Binding<Int>? = nil
    var categories: [String] = []
    let sortedMenu = menuItems.sorted {
        $0.itemName < $1.itemName
    }
    
    init(_ selection: Binding<Int>) {
        self.selection = selection
        for each_item in sortedMenu {
            if !categories.contains(each_item.category) {
                categories.append(each_item.category)
            }
        }
    }
    
    var body: some View {
        List {
            ViewPicker(selection: selection!, false)
                .listRowBackground(Color(red: 243/255, green: 242/255, blue: 247/255))
            
            ForEach(categories, id: \.self) { category in
                Section(content: {
                    ForEach(sortedMenu.filter { $0.category == category }, id: \.self) { menuItem in
                        ListItem(menuItem)
                            .id(menuItem)
                    }
                }, header: { Text(category) }).id(category)
            }
        }.interactiveDismissDisabled()
            .listStyle(.grouped)
    }
}

struct CategoryItemsView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryItemsView(.constant(0))
    }
}
