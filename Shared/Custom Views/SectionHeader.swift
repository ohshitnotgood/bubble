//
//  SectionHeader.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 27/06/2022.
//

import SwiftUI
import Essentials

struct SectionHeader: View {
    @State var title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        VStack (spacing: 0) {
            Text(title)
                .bold()
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(3)
                .padding(.leading)
                .background(
                    VisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
                )
            
            Divider()
        }
    }
}

