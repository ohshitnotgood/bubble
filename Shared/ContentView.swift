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
    
    @State private var showItemsView    : Bool = false
    @State private var showSettingsView : Bool = false
    
    
    var body: some View {
        NavigationView {
            Group {
                VStack {
                    Text("Click on the ")
                    +
                    
                    Text(Image(systemName: "square.and.pencil")).bold()
                    +
                    
                    Text(" icon to add items from the menu or the ")
                    +
                    
                    Text(Image(systemName: "gearshape")).bold()
                    +
                    
                    Text(" icon to go add items to the menu.")
                }.padding(30)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
            }.navigationTitle("Orders")
                .sheet(isPresented: $showItemsView, content: { ItemsView() })
                .sheet(isPresented: $showSettingsView, content: { SettingsView() })
                .toolbar {
                    
                    // MARK: Delete button
                    ToolbarItem(placement: .bottomBar, content: {
                        Button(action: {
                            showItemsView = true
                        }) {
                            Image(systemName: "trash")
                        }
                    })
                    
                    // MARK: New Item button
                    ToolbarItem(placement: .bottomBar, content: {
                        Button(action: {
                            showItemsView = true
                        }) {
                            Image(systemName: "square.and.pencil")
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
