//
//  HistoryView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 28/06/2022.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var menuItemStore: MenuItemStore
    @EnvironmentObject var orderStore   : OrderStore
    
    @State private var dataDidFinishLoading = false
    @State private var search = ""
    let data = Order.pizza
    
    var body: some View {
        Group {
            if dataDidFinishLoading {
                if orderStore.history.isEmpty {
                    Text("No orders")
                        .foregroundStyle(.secondary)
                } else {
                    List {
                        ForEach(orderStore.history, id: \.self) {
                            OrderCellView($0, viewMode: true)
                        }
                    }.listStyle(.plain)
                        .searchable(text: $search)
                }
            } else {
                VStack (spacing: 10) {
                    ProgressView()
                    Text("LOADING...")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }
            }
        }.navigationTitle("Order History")
            .onAppear {
                Task {
                    try await orderStore.load()
                    dataDidFinishLoading = true
                }
            }
            .listStyle(.inset)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HistoryView()
                .environmentObject(MenuItemStore())
                .environmentObject(OrderStore())
        }
    }
}
