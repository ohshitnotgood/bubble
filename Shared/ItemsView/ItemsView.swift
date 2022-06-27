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
        VStack (spacing: 0) {
            VStack {
                HStack (alignment: .center) {
                    Button("Cancel") {
                        
                    }.padding(.horizontal)
                        .opacity(0)
                    
                    Spacer()
                    
                    Text("Menu")
                        .font(.headline).bold()
                    
                    Spacer()
                    
                    Button("Cancel") {
                        dismiss()
                    }.padding(.horizontal)
                }
                
                ViewPicker(selection: $selection, true)
                
            }.padding(.top)
                .background(
                    VisualEffectView(.systemThinMaterial)
                        .edgesIgnoringSafeArea(.top)
                )
            
            if selection == 0 {
                withAnimation {
                    AlphabeticItemsView()
                }
            } else if selection == 1 {
                withAnimation {
                    CategoryItemsView()
                }
            } else if selection == 2 {
                withAnimation {
                    IngredientsItemsView()
                }
            } else if selection == 3 {
                withAnimation {
                    CustomItemsView()
                }
            }
        }
    }
}

fileprivate struct ViewPicker: View {
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
            .padding(.horizontal)
            .padding(.vertical, 10)
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
