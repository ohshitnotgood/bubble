//
//  OrderViewCell.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 5/07/2022.
//

import SwiftUI

struct OrderCellView: View {
    @State private var order: Order
    
    init(_ order: Order) {
        self._order = State(initialValue: order)
    }
    
    var body: some View {
        NavigationLink {
            OrderCustomizerView(inEditMode: order)
        } label: {
            HStack {
                Text("x \(Int(order.quantity))")
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .foregroundStyle(.tertiary)
                    .frame(maxWidth: 35, maxHeight: .infinity, alignment: .leading)
                
                VStack (alignment: .leading) {
                    Text(order.menuItem.itemName)
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
                    OrderCellView(Order.pasta)
                    OrderCellView(Order.pizza)
                } header: {
                    Text("Person 1")
                }
            }.listStyle(.inset)
                .navigationTitle("Orders")
        }
        .preferredColorScheme(.dark)
    }
}
