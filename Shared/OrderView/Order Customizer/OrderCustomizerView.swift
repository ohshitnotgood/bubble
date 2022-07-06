//
//  OrderCustomizerView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 27/06/2022.
//

import SwiftUI

struct OrderCustomizerView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var menuItem: MenuItem
    @ObservedObject var vm: OrderCustomizerViewModel
    @EnvironmentObject var orderStore: OrderStore
    
    init(_ menuItem: MenuItem) {
        self._menuItem = State(initialValue: menuItem)
        self.vm = OrderCustomizerViewModel(menuItem)
    }
    
    init(_ menuItem: MenuItem, order: Order) {
        self._menuItem = State(initialValue: menuItem)
        self.vm = OrderCustomizerViewModel(menuItem)
    }
    
    var body: some View {
        List {
            Section {
                Stepper("Servings size", value: $vm.servingSize)
            } footer: {
                Text("**\(vm.servingSize) people**")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            Section(content: {
                ForEach(menuItem.regularIngredients.indices, id: \.self) {
                    Toggle(menuItem.regularIngredients[$0], isOn: $vm.regularIngredientToggleValues[$0].isOn)
                }
                
                
            }, header: {
                Text("Regular Ingredients")
            })
            
            if menuItem.extraIngredients.count > 0 {
                Section(content: {
                    ForEach(menuItem.extraIngredients.indices, id: \.self) {
                        Toggle(menuItem.extraIngredients[$0], isOn: $vm.extraIngredientsToggleValues[$0].isOn)
                    }
                }, header: {
                    Text("Extra Ingredients")
                })
            }
            
            Section (content: {
                TextEditor(text: $vm.notes)
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
                        addToOrder()
                    }.disabled(!vm.isOrderComplete)
                })
            }
    }
    
    func addToOrder() {
        if vm.isOrderComplete {
            let order = Order(name: menuItem.itemName, regularIngredients: vm.selectedFromRegular, extraIngredients: vm.selectedFromExtra, notes: vm.notes, quantity: Double(vm.servingSize))
            orderStore.current.append(order)
        }
    }
}

struct MenuCustomizerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OrderCustomizerView(menuItems[3])
                .environmentObject(OrderStore())
        }
    }
}
