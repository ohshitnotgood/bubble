//
//  EditMenuView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 27/06/2022.
//

import SwiftUI

/**
 Displays a list of current items on the menu and provides buttons to add or edit an item on the menu.
*/
struct EditMenuView: View {
    @EnvironmentObject var menuItemStore: MenuItemStore
    
    // Data is shown from this array
    @State private var dataDidFinishLoading = true
    
    private func ingredientsAsString(_ list: [String]) -> String {
        var r = ""
        list.forEach { each_string in
            r += each_string == list.last ? each_string : "\(each_string), "
        }
        
        return r
    }
    
    // MARK: - Body
    var body: some View {
        Group {
            if menuItemStore.items.count > 0 {
            List {
                ForEach(menuItemStore.items, id: \.self) { each_item in
                    NavigationLink(destination: { MenuItemEditorView(inEditMode: each_item)}, label: {
                        Text(each_item.itemName)
                    }).buttonStyle(.plain)
                }
            }
            } else {
                Text("No items")
                    .foregroundStyle(.secondary)
            }
        }.navigationTitle("Edit Menu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: MenuItemEditorView(), label: {
                        Text("Add New Item")
                    })
                }
            }
    }
}

// MARK: - Previews
struct EditMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Text("Background")
                .sheet(isPresented: .constant(true)) {
                    NavigationView {
                        EditMenuView()
                            .environmentObject(MenuItemStore())
                            .environmentObject(SettingsStore())
                    }
                }.preferredColorScheme(.dark)
        }.preferredColorScheme(.dark)
    }
}
