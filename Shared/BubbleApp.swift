//
//  BubbleApp.swift
//  Shared
//
//  Created by Praanto Samadder on 26/06/2022.
//

import SwiftUI

@main
struct BubbleApp: App {
    @ObservedObject var menuItemStore = MenuItemStore()
    @ObservedObject var settings      = SettingsStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(menuItemStore)
                .environmentObject(settings)
        }
    }
}
