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
    
    @Published var regularIngredientsToggleValues: [Bool] = [] {
        didSet {
            updateOrderCompletionFlag()
            
            print("Change detected in regular ingredients toggle values list")
            
            regularIngredientsToggleValues.indices.forEach { idx in
                if regularIngredientsToggleValues[idx] == true {
                    selectedFromRegular.append(menuItem.regularIngredients[idx])
                } else {
                    if let index = selectedFromRegular.firstIndex(of: menuItem.regularIngredients[idx]) {
                        selectedFromRegular.remove(at: index)
                    }
                }
            }
        }
    }
    
    @Published var extraIngredientsToggleValues: [Bool] = [] {
        didSet {
            extraIngredientsToggleValues.indices.forEach { idx in
                if extraIngredientsToggleValues[idx] == true {
                    selectedFromExtra.append(menuItem.extraIngredients[idx])
                } else {
                    if let index = selectedFromExtra.firstIndex(of: menuItem.extraIngredients[idx]) {
                        selectedFromExtra.remove(at: index)
                    }
                }
            }
        }
    }
    
    init(_ menuItem: MenuItem) {
        self.menuItem = menuItem
        menuItem.regularIngredients.forEach { each_ingredient in
            regularIngredientsToggleValues.append(true)
        }
        
        menuItem.extraIngredients.forEach { each_ingredient in
            extraIngredientsToggleValues.append(false)
        }
    }
    
    private func updateOrderCompletionFlag() {
        isOrderComplete = selectedFromRegular.count > 0 && servingSize > 0
    }
}
