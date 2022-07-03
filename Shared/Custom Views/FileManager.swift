//
//  FileManager.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 3/07/2022.
//

import Foundation

extension FileManager {
    func getURL(for fileURLType: FileURLType) throws -> URL {
        try self.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(fileURLType.rawValue)
    }
}

enum FileURLType: String {
    case items          = "menuItems.data"
    case ingredients    = "menuIngredients.data"
    case categories     = "menuCategory.data"
    case warnings       = "menuWarnings.data"
    case orders         = "orders.data"
    case orderHistory   = "order_history.data"
    case settings       = "settings_store.data"
}
