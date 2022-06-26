//
//  ItemsView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 26/06/2022.
//

import SwiftUI

struct ItemsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selection = 0
    @State private var searchText = ""
    
    private var showCustomPickerSegment = true
    
    var body: some View {
        NavigationView {
            Group {
                if selection == 0 {
                    AlphabeticItemsView()
                } else if selection == 1 {
                    CategoryItemsView()
                } else if selection == 2 {
                    IngredientsItemsView()
                } else if selection == 3 {
                    CustomItemsView()
                }
            }.navigationTitle("Menu")
                .navigationBarTitleDisplayMode(.inline)
                .searchable(text: $searchText)
                .toolbar {
                    ToolbarItem(placement: .destructiveAction, content: {
                        Button("Cancel") {
                            dismiss()
                        }
                    })
                    
                    ToolbarItem(placement: .bottomBar, content: {
                        ViewPicker(selection: $selection, showCustomPickerSegment)
                    })
                    
                }
        }
    }
}

struct ViewPicker: View {
    private var showCustomPickerSegment: Bool
    private var selection: Binding<Int>
    
    init(selection: Binding<Int>, _ showCustomPickerSegment: Bool) {
        self.selection               = selection
        self.showCustomPickerSegment = showCustomPickerSegment
    }
    
    var body: some View {
        Picker("", selection: selection, content: {
            Text("Alphabetic")
                .tag(0)
            
            Text("Categoric")
                .tag(1)
            
            Text("Ingredients")
                .tag(3)
            
            if showCustomPickerSegment {
                Text("Custom")
                    .tag(4)
            }
        }).pickerStyle(SegmentedPickerStyle())
    }
}

struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView()
    }
}
