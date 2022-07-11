//
//  OrderViewCell.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 5/07/2022.
//

import SwiftUI

struct OrderCellView: View {
    @State private var order: Order
    private var view_mode = false
    
    init(_ order: Order) {
        self._order = State(initialValue: order)
    }
    
    init(_ order: Order, viewMode: Bool) {
        self._order = State(initialValue: order)
        self.view_mode = true
    }
    
    var body: some View {
        //        NavigationLink {
        //            NavigationLink {
        //                OrderCustomizerView(inEditMode: order)
        //            } label: {
        //                EmptyView()
        //            }
        
        HStack (alignment: .center) {
            VStack (alignment: .leading, spacing: 2) {
                HStack (spacing: 5) {
                    Text(order.name)
                        .bold()
                    Spacer()
                    Text("\(Int(order.quantity)) person")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                    
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.tertiary)
                }
                
                
                Text(order.regularIngredients.sorted().joined(separator: ", "))
                    .font(.callout)
                
                if order.notes.isNotEmpty {
                    Text("Notes: \(order.notes)")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                } else {
                    Text(" ")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
            }
        }.padding(.vertical, 5)
            .overlay {
                NavigationLink {
                    if view_mode {
                        OrderCustomizerView(inViewMode: order)
                    } else {
                        OrderCustomizerView(inEditMode: order)
                    }
                } label: {
                    EmptyView()
                }.opacity(0)
            }
        //        }
    }
}

struct OrderViewCell_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                List {
                    OrderCellView(Order.pasta)
                    OrderCellView(Order.pizza)
                    OrderCellView(Order.spagghetti)
                }.listStyle(.inset)
                    .navigationTitle("Orders")
                    .listRowBackground(Color.white)
            }
        }
    }
}
