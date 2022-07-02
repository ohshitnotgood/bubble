//
//  ContentView.swift
//  Shared
//
//  Created by Praanto Samadder on 26/06/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var selectionMode    : Int    = 0
    @State private var searchText       : String = ""
    
    @State private var showItemsView    : Bool   = false
    @State private var showSettingsView : Bool   = false
    
    @State private var data: [MenuItem] = []
    
    @EnvironmentObject var menuItemStore: MenuItemStore
    
    
    var body: some View {
        NavigationView {
            BlankView($showItemsView)
                .onTapGesture(perform: {
                    showItemsView = true
                }).ignoresSafeArea(.all, edges: .all)
            
            
                .navigationTitle("Orders")
                .sheet(isPresented: $showSettingsView, content: { SettingsView().environmentObject(menuItemStore) })
                .onAppear {
                    // MARK: onAppear
                    Task {
                        try await menuItemStore.loadItems()
                        try await menuItemStore.loadCategories()
                    }
                }
                .toolbar {
                    // MARK: Toolbar
                    ToolbarItem(placement: .bottomBar, content: {
                        Button(action: {
                            showItemsView = true
                        }) {
                            Image(systemName: "trash")
                        }
                    })
                    
                    // MARK: New Item button
                    ToolbarItem(placement: .bottomBar, content: {
                        NavigationLink(isActive: $showItemsView) {
                            ItemsView()
                                .environmentObject(menuItemStore)
                        } label: {
                            Image(systemName: "plus.circle")
                        }
                    })
                    
                    // MARK: Settings button
                    ToolbarItem(placement: .navigationBarTrailing, content: {
                        Button(action: {
                            showSettingsView = true
                        }) {
                            Image(systemName: "gearshape")
                        }
                    })
                }
            
        }
    }
    
    
    fileprivate struct BlankView: View {
        private var showItemsView: Binding<Bool>
        
        init(_ showItemsView: Binding<Bool>) {
            self.showItemsView = showItemsView
        }
        
        var body: some View {
            VStack {
                Spacer()
                
                Text("Click on the ")
                +
                
                Text(Image(systemName: "plus.circle.fill")).bold()
                +
                
                Text(" icon to add items from the menu or the ")
                +
                
                Text(Image(systemName: "gearshape")).bold()
                +
                
                Text(" icon to go add items to the menu.")
                
                Spacer()
                
            }.padding(30)
                .contentShape(Rectangle())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(MenuItemStore())
    }
}
