//
//  ListItem.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 27/06/2022.
//

import SwiftUI

struct ListItem: View {
    @State private var menuItem: MenuItem
    private var itemNumber: String = ""
    
    /// Should be only used inside of ``AlphabeticItemsView``, where item numbers are **not** visible.
    init(_ menuItem: MenuItem) {
        self.menuItem = menuItem
        self.itemNumber = ""
    }
    
    /// Should be only used inside of ``CategoryItemsView`` and ``IngredientsItemsView``, where item numbers **are** visible.
    init(_ menuItem: MenuItem, itemNumber: Int) {
        self.menuItem = menuItem
        self.itemNumber = "\(itemNumber)"
    }
    
    // MARK: Main Body
    var body: some View {
        NavigationLink(destination: OrderCustomizerView(menuItem), label: {
            HStack {
                if !itemNumber.isEmpty {
                    VStack {
                        Text(itemNumber)
                            .font(.system(.callout, design: .rounded))
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.secondary)
                        
                    }.frame(width: 20, alignment: .leading)
                }
                
                VStack(alignment: .leading) {
                    Text(menuItem.itemName)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    
                    Text(menuItem.regularIngredientsAsString())
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                        .lineLimit(1)
                }.frame(maxWidth: .infinity, alignment: .leading)
            }.padding(.vertical, 5)
        }).buttonStyle(.plain)
    }
}

struct ListItem_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                List {
                    ForEach(0...20, id: \.self) { _ in
                        ListItem(menuItems[0])
                    }
                }.listStyle(.plain)
            }
            
            NavigationView {
                List {
                    ForEach(0...20, id: \.self) {
                        ListItem(menuItems[0], itemNumber: $0)
                    }
                }.listStyle(.plain)
            }
        }
    }
}

