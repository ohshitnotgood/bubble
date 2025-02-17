//
//  ItemsView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 26/06/2022.
//

import SwiftUI

struct ItemsView: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var menuItemStore: MenuItemStore
    @EnvironmentObject var settingsStore: SettingsStore
    @EnvironmentObject var orderStore   : OrderStore
    
    @State private var selection: ItemViewType = .nil
    
    var body: some View {
        Group {
            if menuItemStore.items.count == 0 {
                Text("No items saved in the menu.")
                    .foregroundColor(.secondary)
            } else {
                if selection == .categoric {
                    CategoryItemsView()
                } else if selection == .ingredients {
                    IngredientsItemsView()
                } else if settingsStore.data.enableMenuNumbering && selection == .numeric {
                    NumericItemsView()
                } else {
                    AlphabeticItemsView()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Picker("Sort by", selection: $selection) {
                        Text("Alphabetic").tag(ItemViewType.alphabetical)
                        Text("Categoric").tag(ItemViewType.categoric)
                        Text("Ingredients").tag(ItemViewType.ingredients)
                        if settingsStore.data.enableMenuNumbering {
                            Text("Numeric").tag(ItemViewType.numeric)
                        }
                    }
                } label: {
                    if selection == .nil {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    } else {
                        Text(selection.rawValue)
                    }
                }
            }
        }
        .navigationBarTitle("Menu")
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - ViewPicker
struct ViewPicker: View {
    private var showCustomPickerSegment: Bool
    private var selection: Binding<Int>
    
    init(selection: Binding<Int>, _ showCustomPickerSegment: Bool) {
        self.selection               = selection
        self.showCustomPickerSegment = showCustomPickerSegment
    }
    
    var body: some View {
        Picker("View Style", selection: selection, content: {
            Text("Alphabetic")
                .tag(0)
            
            Text("Categoric")
                .tag(1)
            
            Text("Ingredients")
                .tag(2)
            
            if showCustomPickerSegment {
                Text("Custom")
                    .tag(4)
            }
        }).pickerStyle(SegmentedPickerStyle())
    }
}

// MARK: - Previews
struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                ItemsView()
                    .environmentObject(MenuItemStore())
                    .preferredColorScheme(.dark)
            }
            
            NavigationView {
                ItemsView()
                    .environmentObject(MenuItemStore())
                    .preferredColorScheme(.light)
            }
        }
    }
}

enum ItemViewType: String, Equatable, CaseIterable {
    case alphabetical   = "Alphabetic"
    case categoric      = "Categoric"
    case ingredients    = "Ingredients"
    case numeric        = "Numeric"
    case `nil`          = ""
}
