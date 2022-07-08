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
                    
                    VStack (alignment: .leading) {
                        ForEach(order.regularIngredients, id: \.self) {
                            Text($0.trimmingCharacters(in: .whitespacesAndNewlines))
                                .bold()
                                .font(.subheadline)
                        }
                    }.foregroundStyle(.primary)
                        .padding(5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.quaternary)
                        .cornerRadius(10)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.quaternary)
                    
                    
                    if order.notes.isNotEmpty {
                        Text("**Notes**: \(order.notes)")
                    }
                }
            }.padding(.vertical, 5)
        }
        
    }
}

struct OrderViewCell_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                OrderCellView(Order.pasta)
                OrderCellView(Order.pizza)
                OrderCellView(Order.spagghetti)
            }.listStyle(.inset)
                .navigationTitle("Orders")
        }
        .preferredColorScheme(.dark)
    }
}
