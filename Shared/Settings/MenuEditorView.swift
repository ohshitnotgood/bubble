//
//  MenuEditorView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 27/06/2022.
//

import SwiftUI

/**
 `MenuEditorView` displays a list of current items on the menu and provides options to add or edit an item on the menu.
 
 `[MenuEditorView] -> [AddToMenuView]` to add new items on the menu.
 */
struct MenuEditorView: View {
    @EnvironmentObject var menuItemStore: MenuItemStore
    
    // Data is shown from this array
    @State private var list: [MenuItem] = []
    @State private var dataDidFinishLoading = false
    
    // Observes for new item to be added
    @ObservedObject private var menuListUpdater = MenuListUpdater()
    
    var body: some View {
        Group {
            if dataDidFinishLoading {
                List {
                    ForEach(list, id: \.self) { menuItem in
                        Text(menuItem.itemName)
                    }
                }
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
                    NavigationLink(destination: AddToMenuView(), label: {
                        Text("Add New Item")
                    })
                }
            }.onAppear {
                Task { do {
                    try await menuItemStore.load()
                    dataDidFinishLoading = true
                    menuListUpdater.menuListDidFinishUpdating = true
                }}
            }.onReceive(menuListUpdater.$menuListDidFinishUpdating, perform: { _ in
                withAnimation {
                    list = menuItemStore.items
                }
            })
    }
}

fileprivate class MenuListUpdater: ObservableObject {
    @Published var menuListDidFinishUpdating = false
}

struct MenuEditorView_Previews: PreviewProvider {
    static var previews: some View {
        MenuEditorView()
            .environmentObject(MenuItemStore())
    }
}
