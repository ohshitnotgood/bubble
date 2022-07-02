//
//  VisualEffectView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 2/07/2022.
//

import SwiftUI

struct VisualEffectView: UIViewRepresentable {
    var material: UIBlurEffect.Style
    
    init(_ material: UIBlurEffect.Style) {
        self.material = material
    }
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: material))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    }
    
    typealias UIViewType = UIVisualEffectView
}
