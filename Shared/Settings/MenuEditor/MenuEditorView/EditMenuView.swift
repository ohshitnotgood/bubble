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
    // Since update is called in SettingsView, data is upto date.
    @EnvironmentObject var menuItemStore: MenuItemStore
    @EnvironmentObject var setttings    : SettingsStore
    
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
        List {
            ForEach(menuItemStore.items, id: \.self) { each_item in
                // MARK: NavigationLink
                NavigationLink(destination: { MenuEditorView(menuItem: each_item).environmentObject(menuItemStore)}, label: {
                    VStack (alignment: .leading) {
                        HStack {
                            Image(systemName: "line.3.horizontal")
                                .font(.body.weight(.bold))
                                .foregroundStyle(.secondary)
                                .padding(.trailing, 10)
                                .padding(.vertical, 5)
                            
                            Text(each_item.itemName)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.callout)
                                .foregroundStyle(.tertiary)
                        }
                    }.padding(.vertical, 5)
                }).buttonStyle(.plain)
            }
        }.navigationTitle("Edit Menu")
            .listStyle(.inset)
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
