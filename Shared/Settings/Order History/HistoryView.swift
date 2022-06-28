//
//  HistoryView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 28/06/2022.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var menuItemStore: MenuItemStore
    
    var body: some View {
        Form {
            
        }.navigationTitle("Order History")
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
