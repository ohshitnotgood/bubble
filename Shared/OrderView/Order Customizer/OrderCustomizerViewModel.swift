//
//  OrderCustomizerViewModel.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 5/07/2022.
//

import Foundation

class OrderCustomizerViewModel: ObservableObject {
    var edit_mode: Bool
    
    @Published var order: Order {
        didSet {
            if order.quantity < 0 {
                order.quantity = 0
            }
            updateOrderCompletionFlag()
        }
    }
    
    @Published var isOrderComplete: Bool = false
    
    @Published var regularIngredientToggleValues: [(isOn: Bool, value: String)] = [] {
        didSet {
            updateRegularList()
        }
    }
    
    @Published var extraIngredientsToggleValues: [(isOn: Bool, value: String)] = [] {
        didSet {
            updateExtraList()
        }
    }
    
    init(inCreateModeWith menuItem: MenuItem) {
        self.order = Order(menuItem: menuItem)
//        self.menuItem = menuItem
        self.edit_mode = false
        order.menuItem.regularIngredients.forEach { regularIngredientToggleValues.append((isOn: true, value: $0)) }
        order.menuItem.extraIngredients.forEach { extraIngredientsToggleValues.append((isOn: false, value: $0)) }
    }
    
    
    init(inEditModeWith order: Order) {
        self.order = order
        self.edit_mode = true
        order.menuItem.regularIngredients.forEach { regularIngredientToggleValues.append((isOn: order.regularIngredients.contains($0), value: $0)) }
        order.menuItem.extraIngredients.forEach { extraIngredientsToggleValues.append((isOn: order.extraIngredients.contains($0), value: $0)) }
    }
    
    
    private func updateOrderCompletionFlag() {
        isOrderComplete = (order.regularIngredients.count > 0) && (order.quantity > 0)
    }
    
    private func updateRegularList() {
        regularIngredientToggleValues.forEach { isOn, ingredient in
            if isOn {
                order.regularIngredients.appendIfNotContains(ingredient)
            } else {
                order.regularIngredients.removeFirstInstance(of: ingredient)
            }
        }
        updateOrderCompletionFlag()
    }
    
    private func updateExtraList() {
        extraIngredientsToggleValues.forEach { isOn, ingredient in
            if isOn {
                order.extraIngredients.appendIfNotContains(ingredient)
            } else {
                order.extraIngredients.removeFirstInstance(of: ingredient)
            }
        }
        updateOrderCompletionFlag()
    }
}
