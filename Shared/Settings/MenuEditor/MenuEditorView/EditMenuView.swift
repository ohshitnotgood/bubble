//
//  EditMenuView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 27/06/2022.
//

import SwiftUI

/**
 `MenuEditorView` displays a list of current items on the menu and provides options to add or edit an item on the menu.
 
 `[SettingsView] -> [MenuEditorView] -> [AddToMenuView]` to add and edit items in to the menu.
 */
struct EditMenuView: View {
    // Since update is called in SettingsView, data is upto date.
    @EnvironmentObject var menuItemStore: MenuItemStore
    @EnvironmentObject var setttings    : SettingsStore
    
    // Data is shown from this array
    @State private var dataDidFinishLoading = true
    
    private func ingredientsList(_ list: [String]) -> some View {
        var t = Text("")
        list.forEach { each_ingredient in
            t = t + Text("\(each_ingredient), ")
        }
        
        return t.bold()
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            ForEach(menuItems, id: \.self) { each_item in
                // MARK: NavigationLink
                NavigationLink(destination: {
                    MenuEditorView(menuItem: each_item)
                        .environmentObject(menuItemStore)
                    
                }) {
                    // MARK: Link Label
                    VStack (alignment: .leading) {
                        Text(each_item.itemName)
                            .bold()
                        
                        ingredientsList(each_item.regularIngredients)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                        
                    }.padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.quaternary)
                        .cornerRadius(15)
                        .padding(5)
                }.buttonStyle(.plain)
            }
        }.navigationTitle("Edit Menu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: MenuEditorView().environmentObject(menuItemStore), label: {
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
            EditMenuView()
                .preferredColorScheme(.dark)
                .environmentObject(MenuItemStore())
                .environmentObject(SettingsStore())
        }
    }
}
