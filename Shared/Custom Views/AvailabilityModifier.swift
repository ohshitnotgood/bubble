//
//  AvailabilityModifier.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 8/07/2022.
//

import SwiftUI

extension View {
    @ViewBuilder func available(in: UIUserInterfaceIdiom) -> some View {
        if UIDevice.current.userInterfaceIdiom == `in` {
            self
        }
    }
}

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}
