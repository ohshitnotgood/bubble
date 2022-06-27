//
//  ListItem.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 27/06/2022.
//

import SwiftUI

struct ListItem: View {
    private var itemName: String = ""
    private var itemRegularIngredients = ""
    private var itemWarnings: String = ""
    
    private var menuItem: MenuItem
    
    
    init(_ menuItem: MenuItem) {
        self.menuItem = menuItem
        
        
        // MARK: Name
        // Fitting itemName into name
        itemName = menuItem.itemName
        
        // MARK: Regular Ingredients
        // Fitting list of regularIngredients into a string
        makeIngredientsList(menuItem)
        
        // MARK: Warnings
        // Converting list of itemWarnings into a string
        makeWarningList(menuItem)
    }
    
    mutating func makeWarningList(_ menuItem: MenuItem) {
        let itemWarnings = menuItem.warnings
        
        for (idx, each_warning) in itemWarnings.enumerated() {
            if idx == itemWarnings.endIndex - 1 {
                self.itemWarnings = self.itemWarnings + "and " + each_warning
            } else if idx == itemWarnings.endIndex - 2 {
                self.itemWarnings = self.itemWarnings + each_warning + " "
            } else {
                self.itemWarnings = self.itemWarnings + each_warning + ", "
            }
        }
    }
    
    mutating func makeIngredientsList(_ menuItem: MenuItem) {
        let itemRegularIngredients = menuItem.regularIngredients
        
        for (idx, each_ingredient) in itemRegularIngredients.enumerated() {
            if idx == itemRegularIngredients.endIndex - 1 {
                self.itemRegularIngredients = self.itemRegularIngredients + "and " + each_ingredient
            } else if idx == itemRegularIngredients.endIndex - 2 {
                self.itemRegularIngredients = self.itemRegularIngredients + each_ingredient + " "
            } else {
                self.itemRegularIngredients = self.itemRegularIngredients + each_ingredient + ", "
            }
        }
    }
    
    
    // MARK: Main Body
    var body: some View {
        NavigationLink(destination: MenuCustomizerView(self.menuItem), label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(itemName)
                        .fontWeight(.medium)
                    
                    Text(itemRegularIngredients)
                        .font(.footnote.weight(.medium))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    
                    Group {
                        Text(Image(systemName: "exclamationmark.circle"))
                        +
                        
                        Text(" Contains ")
                        +
                        
                        Text(self.itemWarnings)
                        
                    }.font(.footnote)
                        .foregroundColor(.gray)
                    
                    
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(.gray)
            }.padding(.vertical, 5)
        }).buttonStyle(.plain)
    }
}

struct ListItem_Previews: PreviewProvider {
    static var previews: some View {
        ListItem(menuItems[0])
    }
}

