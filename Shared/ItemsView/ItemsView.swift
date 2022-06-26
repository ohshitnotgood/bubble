//
//  ItemsView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 26/06/2022.
//

import SwiftUI

struct ItemsView: View {
    @State private var selection = 0
    
    var body: some View {
        TabView {
            AlphabeticItemsView()
                .tabItem {
                    Label("Alphabetic", systemImage: "character")
                }
            
            CategoryItemsView()
                .tabItem {
                    Label("Categoric", systemImage: "rectangle.3.group")
                }
            
            IngredientsItemsView()
                .tabItem {
                    Label("Ingredients", systemImage: "circle.grid.cross.left.filled")
                }
            
            CustomItemsView()
                .tabItem {
                    Label("Custom", systemImage: "cube.transparent.fill")
                }
        }
    }
}

struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView()
    }
}
