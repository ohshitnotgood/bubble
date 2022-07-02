//
//  ListItem.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 27/06/2022.
//

import SwiftUI

struct ListItem: View {
    @State private var menuItem: MenuItem
    
    init(_ menuItem: MenuItem) {
        self.menuItem = menuItem
    }
    
    // MARK: Main Body
    var body: some View {
        NavigationLink(destination: MenuCustomizerView(menuItem), label: {
            VStack(alignment: .leading) {
                Text(menuItem.itemName)
                    .bold()
                    .foregroundStyle(.primary)
                
                Text(menuItem.regularIngredientsAsString())
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }.frame(maxWidth: .infinity, alignment: .leading)
        }).buttonStyle(.plain)
    }
}

struct ListItem_Previews: PreviewProvider {
    static var previews: some View {
        ListItem(menuItems[0])
    }
}

