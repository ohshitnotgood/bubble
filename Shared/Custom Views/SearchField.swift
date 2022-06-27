//
//  SearchField.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 27/06/2022.
//

import SwiftUI


/**
 
 */
struct SearchField: View {
    var text: Binding<String>
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search in the menu...", text: text)
                .foregroundColor(.gray)
            
        }.padding(5)
            .background(Color(uiColor: .systemGray4))
            .cornerRadius(10)
            .padding(10)
    }
}
