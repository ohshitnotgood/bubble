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
    @Published var regularIngredientsToggleValues: [Bool] = [] {
        didSet {
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
    
    init(_ menuItem: MenuItem) {
        self.menuItem = menuItem
        menuItem.regularIngredients.forEach { each_ingredient in
            regularIngredientsToggleValues.append(false)
        }
    }
}
