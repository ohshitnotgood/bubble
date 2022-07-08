//
//  AddCategoryView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 27/06/2022.
//

import SwiftUI


// Listed bugs
//
// Swipe to delete doesn't work
// Renaming an item to an empty string should remove the item from the list but it doesn't.
@available(iOS, deprecated, message: "Use CategoryPickerView instead.")
struct CategoryEditorView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var menuItemStore: MenuItemStore
    
    @State private var text: String = ""
    @State private var showNewTextField = false
    
    
    func onKeyboardSubmit() {
        menuItemStore.categories.appendIfNotContains(text)
        text = ""
    }
    
    var body: some View {
        Form {
            Section {
                ForEach(menuItemStore.categories.indices, id: \.self) {
                    TextField("", text: $menuItemStore.categories[$0])
                        .onTapGesture {
                            withAnimation {
                                showNewTextField = false
                            }
                        }
                }.onDelete { index_set in
                    menuItemStore.categories.remove(atOffsets: index_set)
                }
                
                
                if showNewTextField {
                    TextField("Category Name", text: $text)
                        .introspectTextField { tf in
                            tf.becomeFirstResponder()
                        }.onSubmit {
                            onKeyboardSubmit()
                            showNewTextField = false
                        }
                        .submitLabel(.done)
                }
                
                Button("Add New Category") {
                    if showNewTextField {
                        onKeyboardSubmit()
                        showNewTextField = true
                    } else {
                        withAnimation {
                            showNewTextField = true
                        }
                    }
                }
            }
            
        }.navigationTitle("Edit Categories")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        menuItemStore.categories.sort()
                        menuItemStore.saveCategories()
                    }
                }
            }
    }
}

struct CategoryEditorView_Preview: PreviewProvider {
    static var previews: some View {
        CategoryEditorView()
            .environmentObject(MenuItemStore())
    }
}
