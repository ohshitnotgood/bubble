//
//  MenuItemStore.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 27/06/2022.
//

import Foundation
import SwiftUI

#warning("Requires testing")
class MenuItemStore: ObservableObject {
    @Published var menuItems: [MenuItem] = []
    
    private func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("menuItems.data")
    }
    
    func load() async throws {
        do {
            let fileURL = try fileURL()
            guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                return
            }
            menuItems = try JSONDecoder().decode([MenuItem].self, from: file.availableData)
        }
    }
    
    func save() async throws {
        do {
            let outfile = try fileURL()
            let data = try JSONEncoder().encode(menuItems)
            try data.write(to: outfile, options: .completeFileProtection)
        }
    }
}
