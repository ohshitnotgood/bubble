//
//  OrderViewCell.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 5/07/2022.
//

import SwiftUI

struct OrderViewCell: View {
    @State private var order: Order
    
    init(_ order: Order) {
        self._order = State(initialValue: order)
    }
    
    var body: some View {
        NavigationLink {
            OrderCustomizerView(MenuItem(itemName: order.name, regularIngredients: order.regularIngredients, warnings: [], extraIngredients: order.extraIngredients, category: ""))
                .environmentObject(MenuItemStore())
        } label: {
            HStack {
                Text("x \(Int(order.quantity))")
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .foregroundStyle(.tertiary)
                    .frame(maxWidth: 35, maxHeight: .infinity, alignment: .leading)
                
                VStack (alignment: .leading) {
                    Text(order.name)
                        .bold()
                    
                    Text("**With**: \(String(order.regularIngredients.map { $0 + ", "}.joined().dropLast().dropLast()))")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                    
                    Text("**Notes**: \(order.notes)")
                        .foregroundStyle(.secondary)
                }
            }.padding(.vertical, 5)
        }
        
    }
}

struct OrderViewCell_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                Section {
                    OrderViewCell(dummyOrder)
                    OrderViewCell(dummyOrder)
                } header: {
                    Text("Person 1")
                }
            }.listStyle(.inset)
                .navigationTitle("Orders")
        }
        .preferredColorScheme(.dark)
    }
}
