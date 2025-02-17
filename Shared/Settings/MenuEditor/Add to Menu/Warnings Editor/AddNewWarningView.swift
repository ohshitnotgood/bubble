//
//  AddNewWarningView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 30/06/2022.
//

import SwiftUI

struct AddNewWarningView: View {
    @State var text: String = ""
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var menuItemStore: MenuItemStore
    
    // Checks if new name is empty and if it isn't,
    // adds new category to list, saves it to local device and
    // dismisses view.
    func saveDataAndDismiss() {
        if text.isEmpty {
            dismiss()
            return
        }
        
        Task {
            menuItemStore.warnings.appendIfNotContains(text)
            try menuItemStore.saveWarnings()
            dismiss()
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name", text: $text)
                        .submitLabel(.done)
                        .onSubmit(saveDataAndDismiss)
                        .introspectTextField { tf in
                            tf.becomeFirstResponder()
                        }.textInputAutocapitalization(.words)
                } header: {
                    Text("Warning Name")
                }
            }.navigationTitle("Add New Category")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction, content: {
                        Button("Save") {
                            saveDataAndDismiss()
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

struct AddNewWarningView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewWarningView()
    }
}
