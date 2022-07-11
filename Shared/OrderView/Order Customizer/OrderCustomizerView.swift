//
//  OrderCustomizerView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 27/06/2022.
//

import SwiftUI

struct OrderCustomizerView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var vm: OrderCustomizerViewModel
    @EnvironmentObject var orderStore: OrderStore
    
    /// Displays ``OrderCustomizerView`` in **create mode**.
    init(inCreateMode menuItem: MenuItem) {
        self.vm = OrderCustomizerViewModel(inCreateModeWith: menuItem)
    }
    
    /// Displays ``OrderCustomizerView`` in **edit mode**.
    init(inEditMode order: Order) {
        self.vm = OrderCustomizerViewModel(inEditModeWith: order)
    }
    
    var body: some View {
        List {
            Section {
                Stepper("Servings size", value: $vm.order.quantity)
            } footer: {
                Text("**\(Int(vm.order.quantity)) people**")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            Section(content: {
                ForEach(vm.order.menuItem.regularIngredients.indices, id: \.self) {
                    Toggle(vm.order.menuItem.regularIngredients[$0], isOn: $vm.regularIngredientToggleValues[$0].isOn)
                }
                
                
            }, header: {
                Text("Regular Ingredients")
            })
            
            if vm.order.menuItem.extraIngredients.count > 0 {
                Section(content: {
                    ForEach(vm.order.menuItem.extraIngredients.indices, id: \.self) {
                        Toggle(vm.order.menuItem.extraIngredients[$0], isOn: $vm.extraIngredientsToggleValues[$0].isOn)
                    }
                }, header: {
                    Text("Extra Ingredients")
                })
            }
            
            Section (content: {
                TextEditor(text: $vm.order.notes)
                    .frame(minHeight: 100)
            }, header: {
                Text("Notes")
            }, footer: {
                Text("This item should take around 15 minutes to prepare.")
            })
        }.navigationTitle(vm.order.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction, content: {
                    Button(vm.edit_mode ? "Save" : "Add") {
                        if vm.edit_mode {
                            saveOrder()
                            dismiss()
                        } else {
                            addToOrder()
                        }
                    }.disabled(!vm.isOrderComplete)
                })
            }
    }
    
    func addToOrder() {
        orderStore.current.append(vm.order)
        Task { try await orderStore.save() }
    }
    
    func saveOrder() {
        Task {
            if let index = orderStore.current.firstIndex(where: { $0.orderId == vm.order.orderId }) {
                orderStore.current[index] = vm.order
            }
            try await orderStore.save()
        }
    }
}

struct MenuCustomizerView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OrderCustomizerView(inCreateMode: MenuItem.pasta)
                .environmentObject(OrderStore())
        }
    }
}
