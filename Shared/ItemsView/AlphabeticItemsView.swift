//
//  AlphabeticItemsView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 26/06/2022.
//

import SwiftUI

/**
 `AlphabeticItemView` allows the waiter to add items from an alphabetically ordered list into the current order.
 
 `[AlphabeticItemView] -> [MenuCustomizerView]`
 */
struct AlphabeticItemsView: View {
    @State private var searchText: String = ""
    @State private var showCancelButton = false
    
    @EnvironmentObject var menuItemStore: MenuItemStore
    @EnvironmentObject var orderStore   : OrderStore
    @EnvironmentObject var settingsStore: SettingsStore
    
    @State private var alphabets: [String] = []
    
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    private func makeAlphabetsList() {
        for each_item in menuItemStore.items {
            if let firstChar = each_item.itemName.first {
                if !alphabets.contains(String(firstChar)) {
                    alphabets.append(String(firstChar))
                }
            }
        }
    }
    
    // MARK: Body
    var body: some View {
        ScrollViewReader { reader in
            ZStack {
                List {
                    ForEach(alphabets, id: \.self) { alphabet in
                        Section(header: Text(alphabet), content: {
                            ForEach(menuItemStore.items.filter { $0.itemName.hasPrefix(alphabet)}, id: \.self) {
                                ListItemCellView($0)
                            }
                        }).id(alphabet)
                    }
                }
                AlphabetsScrollBar(reader, alphabetsInView: alphabets)
            }
        }
            .listStyle(.plain)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .onAppear(perform: makeAlphabetsList)
    }
}

struct AlphabetsScrollBar: View {
    var alphabets = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    var reader: ScrollViewProxy
    var alphabetsInView: [String]
    let generator = UISelectionFeedbackGenerator()
    
    @GestureState private var dragLocation: CGPoint = .zero
    
    
    init(_ reader: ScrollViewProxy, alphabetsInView: [String]) {
        self.reader = reader
        self.alphabetsInView = alphabetsInView
    }
    
    var body: some View {
        VStack {
            ForEach(alphabets, id: \.self) { each_a in
                VStack {
                    Text(each_a).onTapGesture {
                        reader.scrollTo(each_a)
                        if alphabets.contains(each_a) {
                            generator.selectionChanged()
                        }
                    }.padding(.leading)
                }
                .buttonStyle(.plain)
                .font(.caption2.weight(.semibold))
                .foregroundColor(.accentColor)
                .background {
                    GeometryReader { geometry in
                        dragObserver(geometry: geometry, scrollTo: each_a)
                    }
                }
            }
        }
        .padding(5)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .gesture (
            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .updating($dragLocation) { value, drag_location, _ in
                    print("Drag detected at \(value.location)")
                    drag_location = value.location
                }
        )
    }
    
    func dragObserver(geometry: GeometryProxy, scrollTo: String) -> some View {
        if geometry.frame(in: .global).contains(dragLocation) {
            DispatchQueue.main.async {
                print("Scrolling to on drag")
                generator.selectionChanged()
                reader.scrollTo(scrollTo, anchor: .top)
            }
        }
        return Rectangle().foregroundStyle(.background)
    }
}


struct AlphabeticItemsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AlphabeticItemsView()
                .environmentObject(MenuItemStore())
                .environmentObject(SettingsStore())
                .environmentObject(OrderStore())
                .navigationTitle("Menu")
                .searchable(text: .constant(""))
        }
        .preferredColorScheme(.dark)
    }
}
