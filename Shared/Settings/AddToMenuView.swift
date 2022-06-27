//
//  AddToMenuView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 27/06/2022.
//

import SwiftUI

struct AddToMenuView: View {
    
    @State private var itemName: String = ""
    @State private var regIng: [String] = []
    @State private var extraIng: [String] = []
    
    var body: some View {
        List {
            Section (content: {
                TextField("Name", text: $itemName)
            }, header: {
                
            })
            
            #warning("Make draggable")
            Section(content: {
                ForEach(menuItems[0].regularIngredients, id: \.self) { each_ingredient in
                    Text(each_ingredient)
                }
            }, header: {
                Text("Ingredients")
            }, footer: {
                Text("Drag items and drop them in to the lists below.")
            })
            
            Section(content: {
                ForEach(regIng, id: \.self) { each_ingredrient in
                    
                }
                
                Button("Add custom ingredient...") {
                    
                }
            }, header: {
                Text("Regular Ingredients")
            })
            
            Section(content: {
                Button("Add custom ingredient...") {
                    
                }
            }, header: {
                Text("Extra Ingredients")
            })
            
            Section(content: {
                Button (action: {}) {
                    HStack {
                        Image(systemName: "checkmark")
                            .padding(.trailing, 5)
                        
                        Text("Dairy")
                    }
                }.buttonStyle(.plain)
                
                HStack {
                    Image(systemName: "checkmark")
                        .padding(.trailing, 5)
                    Text("Gluten")
                }
                
                Button("Add custom warning...") {
                    
                }
            }, header: {
                Text("Warnings")
            })
            
        }.navigationTitle("Add Item to Menu")
    }
}

struct AddToMenuView_Previews: PreviewProvider {
    static var previews: some View {
        AddToMenuView()
    }
}
