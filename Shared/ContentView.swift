//
//  ContentView.swift
//  Shared
//
//  Created by Praanto Samadder on 26/06/2022.
//

import SwiftUI
import Essentials

struct ContentView: View {
    @State private var showItemsView    : Bool   = false
    @State private var showSettingsView : Bool   = false
    
    @EnvironmentObject var orderStore: OrderStore
    @EnvironmentObject var menuItemStore: MenuItemStore
    @EnvironmentObject var settingsStore: SettingsStore
    
    var body: some View {
        NavigationView {
            Group {
                if orderStore.current.count > 0 {
                    OrderView()
                } else {
                    ScrollView {
                        Text("No orders")
                            .foregroundStyle(.secondary)
                            .background(.background)
                            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight * 3 / 4)
                    }.onTapGesture {
                        showItemsView = true
                    }
                }
                
            }.navigationTitle("Orders")
                .sheet(isPresented: $showSettingsView, content: {
                    SettingsView()
                })
                .onAppear {
                    // MARK: onAppear
                    Task {
                        try menuItemStore.loadItems()
                        try menuItemStore.loadCategories()
                        try menuItemStore.loadIngredients()
                        
                        try await settingsStore.load()
                        try await orderStore.load()
                    }
                }
                .toolbar {
                    // MARK: Toolbar
                    ToolbarItem(placement: .bottomBar, content: {
                        Button(action: {
                            Task {
                                withAnimation {
                                    orderStore.current.forEach {
                                        orderStore.history.insert($0, at: 0)
                                    }
                                    orderStore.current.removeAll()
                                }
                                try await orderStore.save()
                            }
                            
                        }) {
                            Image(systemName: "trash")
                        }
                    })
                    
                    // MARK: New Item button
                    ToolbarItem(placement: .bottomBar, content: {
                        NavigationLink(isActive: $showItemsView) {
                            ItemsView()
                        } label: {
                            Image(systemName: "plus.circle")
                        }.available(in: .phone)
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
        .environmentObject(menuItemStore)
        .environmentObject(settingsStore)
        .environmentObject(orderStore)
    }
}

@available(*, deprecated)
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
