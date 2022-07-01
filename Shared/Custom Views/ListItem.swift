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
                Text(menuItem.itemName).bold()
                
                Text(menuItem.regularIngredientsAsString())
//                    .foregroundColor(.secondary)
//                    .bold()
                    .lineLimit(1)
                
                Group {
                    Text(Image(systemName: "exclamationmark.circle"))
                    +
                    
                    Text(" Contains ")
                    +
                    
                    Text(menuItem.warningsAsAString())
                    
                }.foregroundColor(.secondary)
            }
        }).buttonStyle(.plain)
    }
}

struct ListItem_Previews: PreviewProvider {
    static var previews: some View {
        ListItem(menuItems[0])
    }
}

