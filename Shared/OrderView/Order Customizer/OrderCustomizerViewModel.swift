//
//  OrderCustomizerViewModel.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 5/07/2022.
//

import Foundation

class OrderCustomizerViewModel: ObservableObject {
    var menuItem: MenuItem
    
    @Published var order = Order()
    
    @Published var selectedFromRegular: [String] = []
    @Published var selectedFromExtra: [String] = []
    @Published var notes: String = ""
    @Published var servingSize = 0 {
        didSet {
            if servingSize < 0 {
                servingSize = 0
            }
            updateOrderCompletionFlag()
        }
    }
    
    @Published var isOrderComplete: Bool = false
    
    @Published var regularIngredientToggleValues: [(isOn: Bool, value: String)] = [] {
        didSet {
            regularIngredientToggleValues.forEach { isOn, ingredient in
                if isOn {
                    print("\(ingredient) has been set to \(isOn)")
                    order.regularIngredients.appendIfNotContains(ingredient)
                } else {
                    print("\(ingredient) has been set to \(isOn)")
                    order.regularIngredients.removeFirstInstance(of: ingredient)
                }
            }
            print("\nlist: \(order.regularIngredients)")
            updateOrderCompletionFlag()
        }
    }
    
    @Published var extraIngredientsToggleValues: [(isOn: Bool, value: String)] = [] {
        didSet {
            extraIngredientsToggleValues.forEach { isOn, ingredient in
                if isOn {
                    print("\(ingredient) has been set to \(isOn)")
                    order.extraIngredients.appendIfNotContains(ingredient)
                } else {
                    print("\(ingredient) has been set to \(isOn)")
                    order.extraIngredients.removeFirstInstance(of: ingredient)
                }
            }
            print("\nlist: \(order.extraIngredients)")
            updateOrderCompletionFlag()
        }
    }
    
    init(_ menuItem: MenuItem) {
        self.menuItem = menuItem
        menuItem.regularIngredients.forEach { each_ingredient in
            regularIngredientToggleValues.append((isOn: true, value: each_ingredient))
        }
        
        menuItem.extraIngredients.forEach { each_ingredient in
            extraIngredientsToggleValues.append((isOn: false, value: each_ingredient))
        }
    }
    
    init(with menuItem: MenuItem, and order: Order) {
        self.menuItem = menuItem
        menuItem.regularIngredients.forEach { each_ingredient in
            regularIngredientToggleValues.append((isOn: true, value: each_ingredient))
        }
        
        menuItem.extraIngredients.forEach { each_ingredient in
            extraIngredientsToggleValues.append((isOn: false, value: each_ingredient))
        }
        
        self.order = order
    }
    
    
    private func updateOrderCompletionFlag() {
        isOrderComplete = (selectedFromRegular.count > 0) && (servingSize > 0)
    }
}
