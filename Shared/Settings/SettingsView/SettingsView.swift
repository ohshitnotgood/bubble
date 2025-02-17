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
    @EnvironmentObject var settings     : SettingsStore
    @EnvironmentObject var menuItemStore: MenuItemStore
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    NavigationLink(destination: EditMenuView()) {
                        SettingsLabel("Edit Menu", systemImage: "menucard.fill", color: .green)
                    }.buttonStyle(.plain)
                    
                    
                    NavigationLink(destination: CategoryEditorView()) {
                        SettingsLabel("Edit Saved Categories", systemImage: "filemenu.and.selection", color: .pink)
                    }.buttonStyle(.plain)
                    
                    NavigationLink(destination: EditMenuView()) {
                        SettingsLabel("Edit Saved Ingredients", systemImage: "filemenu.and.selection", color: .accentColor)
                    }.buttonStyle(.plain)
                    
                } header: {
                    Text("Edit saved information")
                }
                
                Section {
                    NavigationLink(destination: HistoryView()) {
                        SettingsLabel("Order History", systemImage: "clock.arrow.circlepath", color: .orange)
                    }.buttonStyle(.plain)
                }
                
                Section {
                    Toggle(isOn: $settings.data.enableMenuNumbering, label: {
                        Text("Enable numbers in menu items")
                    })
                } footer: {
                    Text("This will put numbers before your items on the menu. Enabling this now will automatically number all your items in alphabetical order. You can change the numbers in Menu Editor mode.")
                }
                    
                Section {
                    Toggle(isOn: $settings.data.showWarnings) {
                        Text("Show warnings")
                    }
                    
                    
                    Toggle(isOn: $settings.data.showCustomItemView) {
                        Text("Enable custom filtering")
                    }
                }
                
                #if DEBUG
                Section {
                    Button("Load Demo Data into Menu") {
                        Task {
                            menuItemStore.items.append(MenuItem.pizza)
                            menuItemStore.items.append(MenuItem.pasta)
                            try await menuItemStore.saveAll()
                        }
                    }
                } header: {
                    Text("Testing Data")
                } footer: {
                    Text("This will save a set of dummy data to the menu for testing. If you are using a release version of the app and you are seeing this message, report a bug to praanto@icloud.com.")
                }
                #endif
            }.navigationTitle("Settings")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction, content: {
                        Button("Done") {
                            dismiss()
                        }
                    })
                }
                .onDisappear {
                    Task {
                        try await settings.save()
                    }
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
            .environmentObject(SettingsStore())
    }
}
