//
//  CustomItemsView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 26/06/2022.
//

import SwiftUI

struct NumericItemsView: View {
    @EnvironmentObject var menuItemStore: MenuItemStore
    @EnvironmentObject var settingsStore: SettingsStore
    @EnvironmentObject var orderStore   : OrderStore
    
    @State private var searchText = ""
    @State private var numbers: [Int] = []
    
    @State private var incrementor = 0
    
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = true
    }
    
    var searchResults: [MenuItem] {
        if searchText.isEmpty {
            return menuItemStore.items
        } else {
            return menuItemStore.items.filter {
                $0.itemName.localizedCaseInsensitiveContains(searchText) || $0.regularIngredients.contains(where: {
                    $0.localizedCaseInsensitiveContains(searchText)
                }) || $0.extraIngredients.contains(where: {
                    $0.localizedCaseInsensitiveContains(searchText)
                }) || String($0.itemNumber).localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private func makeNumbersList() {
        let largestItemNumber = menuItemStore.largestItemNumber
        if largestItemNumber > 999 {
            incrementor = 100
        } else if largestItemNumber > 499 {
            incrementor = 50
        } else if largestItemNumber > 99 {
            incrementor = 10
        }
        
        if incrementor == 0 {
            numbers = [1]
            return
        }
        
        for n in stride(from: 0, to: largestItemNumber, by: incrementor) {
            menuItemStore.items.forEach { each_i in
                if (n...n + incrementor).contains(each_i.itemNumber) {
                    numbers.appendIfNotContains(n)
                }
            }
        }
    }
    
    var body: some View {
        ScrollViewReader { reader in
            ZStack {
                List {
                    ForEach(numbers, id: \.self) { each_number in
                        Section {
                            if incrementor == 0 {
                                ForEach(menuItemStore.items.sorted(by: .itemNumber), id: \.self) {
                                    ListItemCellView($0, showItemNumber: settingsStore.data.enableMenuNumbering)
                                }
                            } else {
                                ForEach(menuItemStore.items.filter {
                                    (each_number...each_number + incrementor - 1).contains($0.itemNumber)
                                }.sorted(by: .itemNumber), id: \.self) {
                                    ListItemCellView($0, showItemNumber: settingsStore.data.enableMenuNumbering)
                                }
                            }
                        } header: {
                            Text("\(Int(each_number))")
                        }
                    }
                }.listStyle(.plain)
            }
        }.onAppear {
            makeNumbersList()
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), suggestions: {
            if searchText.isNotEmpty {
                ForEach(searchResults, id: \.self) {
                    ListItemCellView($0)
                }
            }
        })
    }
}

struct CustomItemsView_Previews: PreviewProvider {
    static var previews: some View {
        NumericItemsView()
            .environmentObject(MenuItemStore())
            .environmentObject(SettingsStore())
            .environmentObject(OrderStore())
    }
}
