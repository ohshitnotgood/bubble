//
//  OrderView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 6/07/2022.
//

import SwiftUI

struct OrderView: View {
    @EnvironmentObject var orderStore: OrderStore
    @EnvironmentObject var menuItemStore: MenuItemStore
    @EnvironmentObject var settingsStore: SettingsStore
    
    var body: some View {
        List {
            ForEach(orderStore.current, id: \.self) { each_order in
                OrderViewCell(each_order)
            }
        }.listStyle(.inset)
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OrderView()
                .environmentObject(OrderStore())
                .environmentObject(SettingsStore())
                .environmentObject(MenuItemStore())
                .navigationTitle("Orders")
        }
    }
}
