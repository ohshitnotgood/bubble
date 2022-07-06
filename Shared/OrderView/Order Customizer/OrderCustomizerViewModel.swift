//
//  OrderCustomizerViewModel.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 5/07/2022.
//

import Foundation

class OrderCustomizerViewModel: ObservableObject {
    var menuItem: MenuItem
    
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
    
    init(_ menuItem: MenuItem) {
        self.menuItem = menuItem
        self.order = Order()
        menuItem.regularIngredients.forEach { regularIngredientToggleValues.append((isOn: true, value: $0)) }
        menuItem.extraIngredients.forEach { extraIngredientsToggleValues.append((isOn: false, value: $0)) }
    }
    
    init(with menuItem: MenuItem, and order: Order) {
        self.menuItem = menuItem
        self.order = order
        menuItem.regularIngredients.forEach { regularIngredientToggleValues.append((isOn: true, value: $0)) }
        menuItem.extraIngredients.forEach { extraIngredientsToggleValues.append((isOn: false, value: $0)) }
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
