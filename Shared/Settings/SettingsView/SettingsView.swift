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
                    NavigationLink(destination: MenuEditorView().environmentObject(menuItemStore)) {
                        SettingsLabel("Edit Menu", systemImage: "menucard.fill", color: .green)
                    }.buttonStyle(.plain)
                    
                    
                    NavigationLink(destination: CategoryEditorView().environmentObject(menuItemStore)) {
                        SettingsLabel("Edit Saved Categories", systemImage: "filemenu.and.selection", color: .pink)
                    }.buttonStyle(.plain)
                    
                    NavigationLink(destination: MenuEditorView().environmentObject(menuItemStore)) {
                        SettingsLabel("Edit Saved Ingredients", systemImage: "filemenu.and.selection", color: .accentColor)
                    }.buttonStyle(.plain)
                    
                } header: {
                    Text("Edit saved information")
                }
                
                Section {
                    NavigationLink(destination: HistoryView().environmentObject(menuItemStore)) {
                        SettingsLabel("Order History", systemImage: "clock.arrow.circlepath", color: .orange)
                    }.buttonStyle(.plain)
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

fileprivate struct SettingsLabel: View {
    var text: String
    var systemName: String
    var color: Color
    
    init(_ text: String, systemImage: String, color: Color) {
        self.color = color
        self.text = text
        self.systemName = systemImage
    }
    
    var body: some View {
        HStack (spacing: 15) {
            Image(systemName: systemName)
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
                .background(color)
                .cornerRadius(5)
            
            Text(text)
                .font(.callout)
        }.padding(.vertical, 3)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(MenuItemStore())
    }
}
