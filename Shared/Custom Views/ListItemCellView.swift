//
//  ListItem.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 27/06/2022.
//

import SwiftUI

struct ListItemCellView: View {
    @State private var menuItem: MenuItem
    @State private var showItemNumber: Bool = false
    private var largest_item_number_on_menu: String {
        print("Computing largest item number")
        var r: Int
        do {
            let m = MenuItemStore()
            try m.loadItems()
            r = m.largestItemNumber
        } catch {
            r = 0
        }
        return String(r)
    }
    
    /// Should be only used inside of ``AlphabeticItemsView``, where item numbers are **not** visible.
    init(_ menuItem: MenuItem) {
        self.menuItem = menuItem
    }
    
    /// Should be only used inside of ``CategoryItemsView`` and ``IngredientsItemsView``, where item numbers **are** visible.
    init(_ menuItem: MenuItem, showItemNumber: Bool) {
        self.showItemNumber = showItemNumber
        self.menuItem = menuItem
    }
    
    
    // MARK: Main Body
    var body: some View {
        HStack (alignment: .center) {
            if showItemNumber {
                ZStack {
                    Text("\(largest_item_number_on_menu)")
                        .foregroundStyle(.background)
                    Text("\(Int(menuItem.itemNumber))")
                        .foregroundStyle(.secondary)
                }
            }
            
            VStack(alignment: .leading) {
                Text(menuItem.itemName)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Text(menuItem.regularIngredients.joined(separator: ", ").dropLast().dropLast())
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
                    .lineLimit(1)
            }.frame(maxWidth: .infinity, alignment: .leading)
        }.padding(.vertical, 5)
            .overlay {
                NavigationLink {
                    OrderCustomizerView(inCreateMode: menuItem)
                } label: {
                    EmptyView()
                }.opacity(0)
            }
    }
}

struct ListItem_Previews: PreviewProvider {
    static var previews: some View {
        Group {
//            NavigationView {
//                List {
//                    ForEach(0...20, id: \.self) { _ in
//                        ListItemCellView(MenuItem.pasta)
//                    }
//                }.listStyle(.plain)
//            }
            
            NavigationView {
                List {
                    ForEach(0...20, id: \.self) { _ in
                        ListItemCellView(MenuItem.pasta, showItemNumber: true)
                    }
                }.listStyle(.plain)
            }
        }
    }
}

