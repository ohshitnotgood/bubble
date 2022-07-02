//
//  ItemsView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 26/06/2022.
//

import SwiftUI

struct ItemsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.isSearching) private var isSearching
    
    @EnvironmentObject var menuItemStore: MenuItemStore
    
    @State private var selection: ItemViewType = .alphabetical
    @State private var searchText = ""
    
    private var showCustomPickerSegment = false
    
    var body: some View {
        //        TabView {
        //            AlphabeticItemsView()
        //                .environmentObject(menuItemStore)
        //                .tabItem {
        //                    Label("Alphabetic", systemImage: "textformat.abc.dottedunderline")
        //                }
        //
        //            CategoryItemsView()
        //                .environmentObject(menuItemStore)
        //                .tabItem {
        //                    Label("Categoric", systemImage: "fork.knife")
        //                }
        //
        //            IngredientsItemsView()
        //                .environmentObject(menuItemStore)
        //                .tabItem {
        //                    Label("Ingredients", systemImage: "calendar.day.timeline.trailing")
        //                }
        //        }
        
        VStack {
            if selection == .alphabetical {
                AlphabeticItemsView()
                    .environmentObject(menuItemStore)
            } else if selection == .categoric {
                CategoryItemsView()
                    .environmentObject(menuItemStore)
            } else if selection == .ingredients {
                IngredientsItemsView()
                    .environmentObject(menuItemStore)
            } else if selection == .custom {
                CustomItemsView()
                    .environmentObject(menuItemStore)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Picker("Sort by", selection: $selection) {
                        ForEach(ItemViewType.allCases, id: \.self) { each_type in
                            Text(each_type.rawValue)
                                .tag(each_type)
                        }
                    }
                } label: {
                    Text(selection.rawValue)
                }
            }
        }
        .searchable(text: $searchText, placement: .toolbar, suggestions: {
        })
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
        NavigationView {
            ItemsView()
                .environmentObject(MenuItemStore())
                .preferredColorScheme(.dark)
        }
    }
}

enum ItemViewType: String, Equatable, CaseIterable {
    case alphabetical   = "Alphabetic"
    case categoric      = "Categoric"
    case ingredients    = "Ingredients"
    case custom         = "Custom"
}
