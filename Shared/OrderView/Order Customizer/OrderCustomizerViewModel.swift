//
//  OrderCustomizerViewModel.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 5/07/2022.
//

import Foundation

class OrderCustomizerViewModel: ObservableObject {
    var menuItem: MenuItem
    
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
    
    @Published var regularIngredients: [(isOn: Bool, value: String)] = [] {
        didSet {
            regularIngredients.forEach { isOn, ingredient in
                if isOn {
                    print("\(ingredient) has been set to \(isOn)")
                    selectedFromRegular.appendIfNotContains(ingredient)
                } else {
                    print("\(ingredient) has been set to \(isOn)")
                    selectedFromRegular.removeFirstInstance(of: ingredient)
                }
            }
            print("\nlist: \(selectedFromRegular)")
            updateOrderCompletionFlag()
        }
    }
    
    @Published var extraIngredients: [(isOn: Bool, value: String)] = [] {
        didSet {
            extraIngredients.forEach { isOn, ingredient in
                if isOn {
                    print("\(ingredient) has been set to \(isOn)")
                    selectedFromExtra.appendIfNotContains(ingredient)
                } else {
                    print("\(ingredient) has been set to \(isOn)")
                    selectedFromExtra.removeFirstInstance(of: ingredient)
                }
            }
            print("\nlist: \(selectedFromExtra)")
            updateOrderCompletionFlag()
        }
    }
    
    init(_ menuItem: MenuItem) {
        self.menuItem = menuItem
        menuItem.regularIngredients.forEach { each_ingredient in
            regularIngredients.append((isOn: true, value: each_ingredient))
        }
        
        menuItem.extraIngredients.forEach { each_ingredient in
            extraIngredients.append((isOn: false, value: each_ingredient))
        }
    }
    
    
    private func updateOrderCompletionFlag() {
        isOrderComplete = (selectedFromRegular.count > 0) && (servingSize > 0)
    }
}
