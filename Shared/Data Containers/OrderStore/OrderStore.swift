//
//  OrderStore.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 3/07/2022.
//

import Foundation

class OrderStore: ObservableObject {
    @Published var current: [Order] = []
    @Published var history: [Order] = []
    
    func load() async throws {
        try await load_current()
        try await load_history()
    }
    
    func save() async throws {
        try await save_current()
        try await save_history()
    }
    
    private func load_current() async throws {
        let fileURL = try FileManager.default.getURL(for: .orders)
        guard let file = try? FileHandle(forReadingFrom: fileURL) else { return }
        current = (try JSONDecoder().decode([Order].self, from: file.availableData))
    }
    
    private func load_history() async throws {
        let fileURL = try FileManager.default.getURL(for: .orderHistory)
        guard let file = try? FileHandle(forReadingFrom: fileURL) else { return }
        history = (try JSONDecoder().decode([Order].self, from: file.availableData))
    }
    
    private func save_current() async throws {
        let outfile = try FileManager.default.getURL(for: .orders)
        let data = try JSONEncoder().encode(current)
        try data.write(to: outfile, options: .completeFileProtection)
    }
    
    private func save_history() async throws {
        let outfile = try FileManager.default.getURL(for: .orderHistory)
        let data = try JSONEncoder().encode(history)
        try data.write(to: outfile, options: .completeFileProtection)
    }
    
    /// Moves orders stored in `current` to `history` and saves to device memory.
    func updateHistory() async throws {
        if !current.isEmpty {
            current.forEach { history.append($0) }
            current = []
            try await save()
        }
    }
}
