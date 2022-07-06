//
//  ContentView.swift
//  Shared
//
//  Created by Praanto Samadder on 26/06/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var showItemsView    : Bool   = false
    @State private var showSettingsView : Bool   = false
    
    @State private var data: [MenuItem] = []
    
    @EnvironmentObject var menuItemStore: MenuItemStore
    @EnvironmentObject var settingsStore: SettingsStore
    @EnvironmentObject var orderStore   : OrderStore
    
    
    var body: some View {
        NavigationView {
            Group {
                if orderStore.current.count > 0 {
                    List {
                        ForEach(orderStore.current, id: \.self) { each_order in
                            OrderViewCell(each_order)
                        }
                    }.listStyle(.inset)
                } else {
                    BlankView($showItemsView)
                        .onTapGesture(perform: {
                            showItemsView = true
                        }).ignoresSafeArea(.all, edges: .all)
                }
                
            }.navigationTitle("Orders")
                .sheet(isPresented: $showSettingsView, content: {
                    SettingsView()
                        .environmentObject(menuItemStore)
                        .environmentObject(settingsStore)
                        .environmentObject(orderStore)
                    
                })
                .onAppear {
                    // MARK: onAppear
                    Task {
                        try await menuItemStore.loadItems()
                        try await menuItemStore.loadCategories()
                        try await settingsStore.load()
                        try await orderStore.load()
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
                                .environmentObject(settingsStore)
                                .environmentObject(orderStore)
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
            
            Text(Image(systemName: "plus.circle")).bold()
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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.dark)
                .environmentObject(MenuItemStore())
                .environmentObject(OrderStore())
                .environmentObject(SettingsStore())
        }
    }
}
