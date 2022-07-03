//
//  RangeReplaceableCollection.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 28/06/2022.
//

import Foundation

extension RangeReplaceableCollection where Element: Equatable {
    @discardableResult
    mutating func appendIfNotContains(_ element: Element) -> (appended: Bool, memberAfterAppend: Element) {
        if let index = firstIndex(of: element) {
            return (false, self[index])
        } else {
            append(element)
            return (true, element)
        }
    }
}

extension Array where Element == String {
    mutating func removeDuplicates() {
        var result = [Element]()
        for value in self {
            if !result.contains(where: { $0.caseInsensitiveCompare(value.trimmingCharacters(in: .whitespacesAndNewlines)) == .orderedSame }) {
                result.append(value)
            }
        }
        self = result
    }
}
