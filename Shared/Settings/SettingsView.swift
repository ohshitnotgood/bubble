//
//  SettingsView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 26/06/2022.
//

import SwiftUI

/**
 `SettingsView` allows user to add
 
 `[SettingsView] -> [MenuEditorView] -> [AddToMenuView]` to add and edit items in to the menu.
 
 
 `[SettingsView] -> [OrderHistoryView]` to view order history
 `[SettingsView] -> [CategoriesEditorView]` to add or edit categories.
 */
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var menuItemStore: MenuItemStore
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: MenuEditorView().environmentObject(menuItemStore)) {
                    Label("Edit Items on Menu...", systemImage: "filemenu.and.selection")
                }.buttonStyle(.plain)
                
                #warning("Fix destination")
                NavigationLink(destination: AddToMenuView()) {
                    Label("Order History", systemImage: "clock.arrow.circlepath")
                }.buttonStyle(.plain)
                
                
            }.navigationTitle("Settings")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction, content: {
                        Button("Done") {
                            dismiss()
                        }
                    })
                }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(MenuItemStore())
    }
}
