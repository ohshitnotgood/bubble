//
//  AlphabeticItemsView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 26/06/2022.
//

import SwiftUI

/**
 `AlphabeticItemView` allows the waiter to add items from an alphabetically ordered list into the current order.
 
 `[AlphabeticItemView] -> [MenuCustomizerView]`
 */
struct AlphabeticItemsView: View {
    @State private var searchText: String = ""
    @State private var showCancelButton = false
    
    var selection: Binding<Int>? = nil
    
    var alphabets: [String] = []
    
    let sortedMenu = menuItems.sorted {
        $0.itemName < $1.itemName
    }
    
    init(_ selection: Binding<Int>) {
        makeAlphabetsList()
        self.selection = selection
    }
    
    mutating func makeAlphabetsList() {
        for each_item in sortedMenu {
            if let firstChar = each_item.itemName.first {
                if !alphabets.contains(String(firstChar)) {
                    alphabets.append(String(firstChar))
                }
            }
        }
    }
    
    // MARK: Body
    var body: some View {
        List {
            ViewPicker(selection: selection!, false)
                .listRowBackground(Color.materiaColor)
            
            ForEach(alphabets, id: \.self) { alphabet in
                Section(header: Text(alphabet), content: {
                    ForEach(sortedMenu.filter { $0.itemName.hasPrefix(alphabet)}, id: \.self) { menuItem in
                        ListItem(menuItem)
                            .id(menuItem)
                            .padding(.vertical, 5)
                    }
                }).id(alphabet)
            }
        }.interactiveDismissDisabled()
            .listStyle(.grouped)
    }
}


struct AlphabeticItemsView_Previews: PreviewProvider {
    static var previews: some View {
        AlphabeticItemsView(.constant(0))
            .preferredColorScheme(.dark)
    }
}
