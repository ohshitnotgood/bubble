//
//  MenuEditorView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 27/06/2022.
//

import SwiftUI

/**
 `MenuEditorView` displays a list of current items on the menu and provides options to add or edit an item on the menu.
 
 `[SettingsView] -> [MenuEditorView] -> [AddToMenuView]` to add and edit items in to the menu.
 */
struct MenuEditorView: View {
    // Since update is called in SettingsView, data is upto date.
    @EnvironmentObject var menuItemStore: MenuItemStore
    
    // Data is shown from this array
    @State private var dataDidFinishLoading = true
    
    // Observes for new item to be added
    @ObservedObject private var menuListUpdater = MenuListUpdater()
    
    
    func ingredientsList(_ list: [String]) -> some View {
        var t = Text("")
        list.forEach { each_ingredient in
            t = t + Text("\(each_ingredient), ")
        }
        
        return t
    }
    
    var body: some View {
        Group {
            if dataDidFinishLoading {
                List {
                    ForEach(menuItemStore.items, id: \.self) { each_item in
                        VStack (alignment: .leading) {
                            Text(each_item.itemName)
                                .bold()
                            ingredientsList(each_item.regularIngredients)
                                .foregroundColor(.gray)
//                            Text(each_item.regularIngredients.first!)
                            
                            Group {
                                Text(Image(systemName: "exclamationmark.triangle.fill")) +
                                Text(" \(each_item.warnings.first!)")
                                    
                            }.foregroundColor(.secondary).font(.body.weight(.bold))
                        }
                    }
                }.listStyle(.inset)
            } else {
                VStack (spacing: 10) {
                    ProgressView()
                    Text("LOADING...")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
            }
            
        }.navigationTitle("Edit Menu")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddToMenuView().environmentObject(menuItemStore), label: {
                        Text("Add New Item")
                    })
                }
            }
    }
}

class MenuListUpdater: ObservableObject {
    @Published var menuListDidFinishUpdating = false
}

struct MenuEditorView_Previews: PreviewProvider {
    static var previews: some View {
        MenuEditorView()
            .preferredColorScheme(.dark)
            .environmentObject(MenuItemStore())
    }
}
