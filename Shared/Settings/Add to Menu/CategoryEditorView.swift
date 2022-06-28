//
//  AddCategoryView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 27/06/2022.
//

import SwiftUI

struct CategoryEditorView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var menuItemStore: MenuItemStore
    
    @State private var text: String = ""
    @State private var testCategories = ["Main Course", "Beverages"]
    
    @State private var showNewCategoryButton = true
    
    
    func saveCategoryData() {
        Task {
            try await menuItemStore.saveCategories()
        }
    }
    
    var body: some View {
        Form {
            Section {
                ForEach(menuItemStore.categories.indices, id: \.self) {
                    TextField("", text: $menuItemStore.categories[$0])
                        .onTapGesture {
                            showNewCategoryButton = true
                        }
                }
                
                if showNewCategoryButton {
                    Button("Add New Category") {
                        showNewCategoryButton.toggle()
                    }
                } else {
                    TextField("Edit Category", text: $text)
                        .introspectTextField { tf in
                            tf.becomeFirstResponder()
                        }.onSubmit {
                            menuItemStore.categories.appendIfNotContains(text)
                            text = ""
                            showNewCategoryButton.toggle()
                        }.submitLabel(.done)
                }
            }
            
        }.navigationTitle("Add New Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button("Done") {
                        saveCategoryData()
                        dismiss()
                    }
                })
            }
        // There is no need to load categories from device as categories are being passed as an
        // environment object.
        // Every time a new category is added, it is saved to device through menuItemStore.saveCategories().
        // Hence, there is no need to reload categories from device.
    }
}

struct CategoryEditorView_Preview: PreviewProvider {
    static var previews: some View {
        CategoryEditorView()
            .environmentObject(MenuItemStore())
    }
}
