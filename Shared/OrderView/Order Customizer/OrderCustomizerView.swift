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
    
    private var view_mode = false
    
    /// Displays ``OrderCustomizerView`` in **create mode**.
    init(inCreateMode menuItem: MenuItem) {
        self.vm = OrderCustomizerViewModel(inCreateModeWith: menuItem)
    }
    
    /// Displays ``OrderCustomizerView`` in **edit mode**.
    init(inEditMode order: Order) {
        self.vm = OrderCustomizerViewModel(inEditModeWith: order)
    }
    
    init(inViewMode order: Order) {
        self.vm = OrderCustomizerViewModel(inEditModeWith: order)
        view_mode = true
    }
    
    var body: some View {
        List {
            Section {
                if view_mode {
                    HStack {
                        Text("Date")
                        Spacer()
                        Text(vm.order.dateTime.formatted(date: .abbreviated, time: .shortened))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                Stepper("Servings size", value: $vm.order.quantity)
                    .disabled(view_mode)
            } footer: {
                Text("**\(Int(vm.order.quantity)) people**")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            Section(content: {
                ForEach(vm.order.menuItem.regularIngredients.indices, id: \.self) {
                    Toggle(vm.order.menuItem.regularIngredients[$0], isOn: $vm.regularIngredientToggleValues[$0].isOn)
                        .disabled(view_mode)
                }
                
                
            }, header: {
                Text("Regular Ingredients")
            })
            
            if vm.order.menuItem.extraIngredients.count > 0 {
                Section(content: {
                    ForEach(vm.order.menuItem.extraIngredients.indices, id: \.self) {
                        Toggle(vm.order.menuItem.extraIngredients[$0], isOn: $vm.extraIngredientsToggleValues[$0].isOn)
                            .disabled(view_mode)
                    }
                }, header: {
                    Text("Extra Ingredients")
                })
            }
            
            Section (content: {
                TextEditor(text: $vm.order.notes)
                    .frame(minHeight: 100)
                    .disabled(view_mode)
            }, header: {
                Text("Notes")
            })
            
            if vm.order.menuItem != MenuItemStore.findItemBy(id: vm.order.menuItem.id)! {
                Section {
                    
                } footer: {
                    Text("*This dish was modified after the order was recorded.*")
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }.navigationTitle(vm.order.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction, content: {
                    if !view_mode {
                        Button(vm.edit_mode ? "Save" : "Add") {
                            if vm.edit_mode {
                                saveOrder()
                                dismiss()
                            } else {
                                addToOrder()
                            }
                        }.disabled(!vm.isOrderComplete)
                    }
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
