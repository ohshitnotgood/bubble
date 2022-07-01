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
    
    private var showCustomPickerSegment = false

    var body: some View {
        NavigationView {
            Group {
                if selection == 0 {
                    AlphabeticItemsView($selection)
                } else if selection == 1 {
                    CategoryItemsView($selection)
                } else if selection == 2 {
                    IngredientsItemsView($selection)
                } else if selection == 3 {
                    CustomItemsView()
                }
            }.toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }.searchable(text: $searchText, placement: .navigationBarDrawer)
                .navigationBarTitle("Menu")
                .navigationBarTitleDisplayMode(.inline)
            
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
        Picker("View Style", selection: selection, content: {
            Text("Alphabetic")
                .tag(0)
            
            Text("Categoric")
                .tag(1)
            
            Text("Ingredients")
                .tag(2)
            
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

struct VisualEffectView: UIViewRepresentable {
    var material: UIBlurEffect.Style
    
    init(_ material: UIBlurEffect.Style) {
        self.material = material
    }
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: material))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    }
    
    typealias UIViewType = UIVisualEffectView
    
    
}
