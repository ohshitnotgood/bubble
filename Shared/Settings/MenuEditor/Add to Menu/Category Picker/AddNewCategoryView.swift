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
    @State private var categoryAlreadyExists = false
    
    // Checks if new name is empty and if it isn't,
    // adds new category to list, saves it to local device and
    // dismisses view.
    func saveDataAndDismiss() {
        if !text.isEmpty {
            Task {
                menuItemStore.categories.appendIfNotContains(text.trimmingCharacters(in: .whitespacesAndNewlines))
                try await menuItemStore.saveCategories()
                dismiss()
            }
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $text)
                        .onChange(of: text, perform: { newValue in
                            categoryAlreadyExists = menuItemStore.categories.contains(where: { $0.lowercased() == newValue.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                            })
                        })
                        .submitLabel(.done)
                        .onSubmit(saveDataAndDismiss)
                        .introspectTextField { tf in
                            tf.becomeFirstResponder()
                        }.textInputAutocapitalization(.words)
                } header: {
                    Text("Category Name")
                } footer: {
                    Text("A category with this name already exists.")
                        .foregroundColor(.red)
                        .opacity(categoryAlreadyExists ? 1 : 0)
                }
            }.navigationTitle("Add New Category")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction, content: {
                        Button("Save") {
                            saveDataAndDismiss()
                        }
                        .disabled(text.isEmpty || categoryAlreadyExists)
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
