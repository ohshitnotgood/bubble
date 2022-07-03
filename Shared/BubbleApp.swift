//
//  BubbleApp.swift
//  Shared
//
//  Created by Praanto Samadder on 26/06/2022.
//

import SwiftUI

@main
struct BubbleApp: App {
    var menuItemStore = MenuItemStore()
    var settingsStore = SettingsStore()
    var orderStore    = OrderStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(menuItemStore)
                .environmentObject(settingsStore)
                .environmentObject(orderStore)
        }
    }
}
