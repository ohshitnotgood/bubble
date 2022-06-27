//
//  AlphabeticItemsView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 26/06/2022.
//

import SwiftUI

struct AlphabeticItemsView: View {
    // 243, 242, 247
    @State private var searchText: String = ""
    @State private var showCancelButton = false
    
    
    var alphabets: [String] = []
    
    let sortedMenu = menuItems.sorted {
        $0.itemName < $1.itemName
    }
    
    init() {
        makeAlphabetsList()
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
            ForEach(alphabets, id: \.self) { alphabet in
                Section(header: Text(alphabet), content: {
                    ForEach(sortedMenu.filter { $0.itemName.hasPrefix(alphabet)}, id: \.self) { menuItem in
                        ListItem(menuItem)
                            .id(menuItem)
                    }
                }).id(alphabet)
            }
        }.interactiveDismissDisabled()
            .listStyle(.grouped)
    }
}


struct AlphabeticItemsView_Previews: PreviewProvider {
    static var previews: some View {
        AlphabeticItemsView()
    }
}
