//
//  AlphabeticItemsView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 26/06/2022.
//

import SwiftUI

struct AlphabeticItemsView: View {
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            List {
                
            }.navigationTitle("Alphabetic")
                .searchable(text: $searchText)
        }
    }
}

struct AlphabeticItemsView_Previews: PreviewProvider {
    static var previews: some View {
        AlphabeticItemsView()
    }
}
