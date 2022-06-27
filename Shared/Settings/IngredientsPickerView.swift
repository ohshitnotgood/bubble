//
//  IngredientsPickerView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 27/06/2022.
//

import SwiftUI

struct IngredientsPickerView: View {
    @State var availableIngredients: [String] = ["Cheese"]
    @State var chosenIngredients: [String] = ["Mayonese"]
    
    @State private var showCustomIngredientsTextField = true
    
    #warning("Make custom ingredients editable")
    var body: some View {
        List {
            Section(content: {
                ForEach(Array(zip(availableIngredients.indices, availableIngredients)), id: \.0) { idx, each_ingredient in
                    Button(each_ingredient) {
                        withAnimation {
                            availableIngredients.remove(at: idx)
                            chosenIngredients.append(each_ingredient)
                        }
                    }.foregroundColor(.sensiBlack)
                }
                
                Button("Add custom ingredient...") {
                    
                }
            }, header: {
                Text("Pick Ingredients")
            }, footer: {
                Text("Choose items from this list to include with Basic Ingredients.")
            })
            
            Section(content: {
                ForEach(Array(zip(chosenIngredients.indices, chosenIngredients)), id: \.0) { idx, each_ingredient in
                    Button(each_ingredient) {
                        withAnimation {
                            chosenIngredients.remove(at: idx)
                            availableIngredients.append(each_ingredient)
                        }
                    }.foregroundColor(.sensiBlack)
                }
                
                Button("Add custom ingredient...") {
                    
                }
            }, header: {
                Text("Basic Ingredients")
            })
        }
    }
}

struct IngredientsPickerView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientsPickerView()
    }
}
