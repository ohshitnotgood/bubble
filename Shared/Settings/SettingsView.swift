//
//  SettingsView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 26/06/2022.
//

import SwiftUI

/**
 `SettingsView` allows user to add
 
 `[SettingsView] -> [MenuEditorView] -> [AddToMenuView] -> [CategoryEditorView]`
 
 
 `[SettingsView] -> [OrderHistoryView]` to view order history
 `[SettingsView] -> [CategoriesEditorView]` to add or edit categories.
 */
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var menuItemStore: MenuItemStore
    
    var body: some View {
        NavigationView {
            Form {
                
                Section {
                    #warning("Fix destination")
                    NavigationLink(destination: AddToMenuView().environmentObject(menuItemStore)) {
                        Label("Order History", systemImage: "clock.arrow.circlepath")
                    }.buttonStyle(.plain)
                }
                
                Section {
                    NavigationLink(destination: MenuEditorView().environmentObject(menuItemStore)) {
                        Label("Edit Menu", systemImage: "menucard")
                    }.buttonStyle(.plain)
                    
                    
                    NavigationLink(destination: CategoryEditorView().environmentObject(menuItemStore)) {
                        Label("Edit Categories", systemImage: "filemenu.and.selection")
                    }.buttonStyle(.plain)
                    
                    NavigationLink(destination: MenuEditorView().environmentObject(menuItemStore)) {
                        Label("Edit Ingredients", systemImage: "filemenu.and.selection")
                    }.buttonStyle(.plain)
                    
                } header: {
                    Text("Edit stored data")
                }
                
                
                
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
