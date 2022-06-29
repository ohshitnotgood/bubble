//
//  AddNewCategoryView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 28/06/2022.
//

import SwiftUI

struct AddNewCategoryView: View {
    @State var text: String = ""
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var menuItemStore: MenuItemStore
    
    // Checks if new name is empty and if it isn't,
    // adds new category to list, saves it to local device and
    // dismisses view.
    func save_data() {
        if !text.isEmpty {
            Task {
                menuItemStore.categories.appendIfNotContains(text)
                try await menuItemStore.saveCategories()
            }
        }
        dismiss()
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $text)
                        .submitLabel(.done)
                        .onSubmit(save_data)
                        .introspectTextField { tf in
                            tf.becomeFirstResponder()
                        }.textInputAutocapitalization(.words)
                } header: {
                    Text("Category Name")
                }
            }.navigationTitle("Add New Category")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction, content: {
                        Button("Save") {
                            save_data()
                        }.disabled(text.isEmpty)
                    })
                    
                    ToolbarItem(placement: .navigationBarLeading, content: {
                        Button("Cancel") {
                            dismiss()
                        }
                    })
            }
        }
    }
}

struct AddNewCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewCategoryView()
            .environmentObject(MenuItemStore())
    }
}
