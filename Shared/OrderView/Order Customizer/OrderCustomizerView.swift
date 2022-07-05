//
//  OrderCustomizerView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 27/06/2022.
//

import SwiftUI

struct OrderCustomizerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var editorText = ""
    @State private var isToggleOn = false
    
    @State private var servingSize = 0
    @State private var menuItem: MenuItem
    
    @State private var selectedRegulars: [String] = []
    @State private var selectedExtras  : [String] = []
    
    
    @ObservedObject var vm: OrderCustomizerViewModel
    
    init(_ menuItem: MenuItem) {
        self._menuItem = State(initialValue: menuItem)
        self.vm = OrderCustomizerViewModel(menuItem)
    }
    
    var body: some View {
        List {
            Section {
                Stepper("Servings size", value: $servingSize)
            } footer: {
                Text("Serving for **\(servingSize) people**.")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            Section(content: {
                ForEach(menuItem.regularIngredients.indices, id: \.self) {
                    Toggle(menuItem.regularIngredients[$0], isOn: $vm.regularIngredientsToggleValues[$0])
                }
                
                
            }, header: {
                Text("Regular Ingredients")
            })
            
            Section(content: {
                ForEach(menuItem.extraIngredients, id: \.self) { each_ingredient in
                    Toggle(each_ingredient, isOn: $isToggleOn)
                        .toggleStyle(.switch)
                }
                
                
            }, header: {
                Text("Extra Ingredients")
            }, footer: {
                Text("The parmesan costs extra.")
            })
            
            
            Section (content: {
                TextEditor(text: $editorText)
                    .frame(minHeight: 100)
            }, header: {
                Text("Notes")
            }, footer: {
                Text("This item should take around 15 minutes to prepare.")
            })
        }.navigationTitle(menuItem.itemName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction, content: {
                    Button("Add") {
                        dismiss()
                    }
                })
            }
    }
    
    func addToOrder() {
        
    }
}

struct MenuCustomizerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OrderCustomizerView(menuItems[3])
        }
    }
}
