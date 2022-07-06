//
//  RangeReplaceableCollection.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 28/06/2022.
//

import Foundation

extension RangeReplaceableCollection where Element: Equatable {
    /// Appends provided element to the list if the list doesn't already contain it.
    mutating func appendIfNotContains(_ element: Element) {
        if !self.contains(element) {
            self.append(element)
        }
//        if let index = firstIndex(of: element) {
//            self.remove(at: index)
//        } else {
//            self.append(element)
//        }
    }
    
    /// Removes provided element from the list if the element is already in there. Otherwise, the element is appended to the list.
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
    
    /// Strips each element of unnecessary whitespaces and new lines.
    mutating func stripAll() {
        self = self.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    }
    
    mutating func removeFirstInstance(of string: String) {
        if let index = self.firstIndex(of: string) {
            self.remove(at: index)
        }
    }
}
