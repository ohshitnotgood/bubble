//
//  SectionHeader.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 27/06/2022.
//

import SwiftUI

struct SectionHeader: View {
    @State var title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        VStack (spacing: 0) {
            Divider()
            
            Text(title)
                .bold()
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(3)
                .padding(.leading)
                .background(
                    VisualEffectView(.systemThinMaterial)
                )
            
            Divider()
        }
    }
}

