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
    
    mutating func removeIfContainsElseAppend(_ element: Element) {
        if self.contains(element) {
            if let index = self.firstIndex(of: element) {
                self.remove(at: index)
            }
        } else {
            self.append(element)
        }
    }
}

extension Array where Element == String {
    /// Removes repeating strings in a list.
    mutating func removeDuplicates() {
        var result = [Element]()
        for value in self {
            if !result.contains(where: { $0.caseInsensitiveCompare(value.trimmingCharacters(in: .whitespacesAndNewlines)) == .orderedSame }) {
                result.append(value)
            }
        }
        self = result
    }
    
    mutating func removeIfContainsElseAppend(_ e: String) {
        if self.contains(e) {
            if let index = self.firstIndex(of: e) {
                self.remove(at: index)
            }
        } else {
            self.append(e)
        }
    }
    
    mutating func stripAll() {
        self = self.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    }
    
    mutating func removeFirstInstance(of string: String) {
        if let index = self.firstIndex(of: string) {
            self.remove(at: index)
        }
    }
}
