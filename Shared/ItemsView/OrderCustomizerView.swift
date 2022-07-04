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
    
    @State private var regularIngredients : [String]
    @State private var extraIngredients   : [String]
    @State private var itemName           : String
    
    @State private var servingSize        = ""
    
    init(_ menuItem: MenuItem) {
        self._regularIngredients = State(initialValue: menuItem.regularIngredients)
        self._extraIngredients = State(initialValue: menuItem.extraIngredients)
        self._itemName = State(initialValue: menuItem.itemName)
    }
    
    var body: some View {
        List {
            Section {
                HStack {
                    Text("Serving for")
                    
                    Spacer()
                    
                    TextField("1", text: $servingSize)
                        .textFieldStyle(.roundedBorder)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: true, vertical: true)
                        .keyboardType(.numberPad)
                }
            }
            
            Section(content: {
                ForEach(regularIngredients, id: \.self) { each_ingredient in
                    Toggle(each_ingredient, isOn: $isToggleOn)
                        .toggleStyle(.switch)
                }
                
                
            }, header: {
                Text("Regular Ingredients")
            })
            
            Section(content: {
                ForEach(extraIngredients, id: \.self) { each_ingredient in
                    Toggle(each_ingredient, isOn: $isToggleOn)
                        .toggleStyle(.switch)
                }
                
                
            }, header: {
                Text("Extra Ingredients")
            }, footer: {
                Text("The parmesan costs extra.")
            })
            
            Section {
                
            } header: {
                Text("Warnings")
            } footer: {
                VStack {
                    Text("Milk")
                    Text("Milk")
                }
            }
            
            Section (content: {
                TextEditor(text: $editorText)
                    .frame(minHeight: 100)
            }, header: {
                Text("Notes")
            }, footer: {
                Text("This item should take around 15 minutes to prepare.")
            })
        }.navigationTitle(itemName)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .destructiveAction, content: {
                    Button("Cancel") {
                        dismiss()
                    }
                })
            }
    }
}

struct MenuCustomizerView_Previews: PreviewProvider {
    static var previews: some View {
        OrderCustomizerView(menuItems[3])
    }
}
