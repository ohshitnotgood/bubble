//
//  ContentView.swift
//  Shared
//
//  Created by Praanto Samadder on 26/06/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var selectionMode: Int = 0
    
    var body: some View {
        NavigationView {
            Text("Hello World")
                .toolbar {
                    ToolbarItem(placement: .principal, content: {
                        Picker("Sort by:", selection: $selectionMode) {
                            Text("Alphabetic")
                                .tag(0)
                            
                            Text("Category")
                                .tag(1)
                            
                            Text("Ingredient")
                                .tag(3)
                            
                            Text("Custom")
                                .tag(3)
                        }.pickerStyle(SegmentedPickerStyle())
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
