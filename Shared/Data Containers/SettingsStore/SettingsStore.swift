//
//  SettingsStore.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 3/07/2022.
//

import Foundation

class SettingsStore: ObservableObject {
    @Published var data = SettingsJSON()
    
    private func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                              in: .userDomainMask,
                                              appropriateFor: nil,
                                              create: false)
        .appendingPathComponent("settings_store.data")
    }
    
    /// Saves changed settings to device memory.
    func save() async throws {
        let outfile = try fileURL()
        let data = try JSONEncoder().encode(data)
        try data.write(to: outfile, options: .completeFileProtection)
    }
    
    func load() async throws {
        let fileURL = try fileURL()
        guard let file = try? FileHandle(forReadingFrom: fileURL) else {
            return
        }
        data = (try JSONDecoder().decode(SettingsJSON.self, from: file.availableData))
    }
}

struct SettingsJSON: Codable {
    var enableMenuNumbering     = false
    var showCustomItemView      = false
    var showWarnings            = false
}
