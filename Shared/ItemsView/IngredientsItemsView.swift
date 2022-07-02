//
//  IngredientsItemsView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 26/06/2022.
//

import SwiftUI

struct IngredientsItemsView: View {
    var selection: Binding<Int>? = nil
    var ingredients: [String] = []
    
    init(_ selection: Binding<Int>) {
        self.selection = selection
        makeIngredientsList()
    }
    
    let sortedMenu = menuItems.sorted {
        $0.itemName < $1.itemName
    }
    
    mutating func makeIngredientsList() {
        sortedMenu.forEach { each_item in
            each_item.regularIngredients.forEach { each_ingredient in
                if !ingredients.contains(each_ingredient) {
                    ingredients.append(each_ingredient)
                }
            }
        }
        ingredients.sort()
    }
    
    var body: some View {
        List {
            ForEach(ingredients, id: \.self) { each_ingredient in
                Section {
                    ForEach(sortedMenu, id: \.self) { menu_item in
                        if menu_item.regularIngredients.contains(each_ingredient) {
                            ListItem(menu_item)
                        }
                    }
                } header: {
                    Text(each_ingredient)
                }

            }
        }.listStyle(.inset)
    }
}

struct IngredientsItemsView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientsItemsView(.constant(2))
    }
}
