//
//  AddCategoryView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 27/06/2022.
//

import SwiftUI

struct AddCategoryView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var text: String = ""
    var categories: Binding<[String]>
    
    var body: some View {
        List {
            TextField("Category Name", text: $text)
        }.navigationTitle("Add New Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button("Done") {
                        dismiss()
                    }
                })
            }.onDisappear {
                if !text.isEmpty {
                    categories.wrappedValue.append(text)
                }
            }
    }
}
