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
        Form {
            Section {
                TextField("Name", text: $text)
//                    .introspectTextField(customize: { tf in
//                        tf.becomeFirstResponder()
//                    })
                    .submitLabel(.done)
                .onSubmit(save_data)
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
            }
    }
}

struct AddNewCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewCategoryView()
            .environmentObject(MenuItemStore())
    }
}
