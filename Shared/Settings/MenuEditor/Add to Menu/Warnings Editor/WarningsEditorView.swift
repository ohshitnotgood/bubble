//
//  WarningsEditorView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 30/06/2022.
//

import SwiftUI

struct WarningsEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var menuItemStore: MenuItemStore
    
    @State private var showAddNewWarningView = false
    
    var body: some View {
        NavigationView {
            Form {
                if menuItemStore.warnings.count > 0 {
                    Section {
                        ForEach(menuItemStore.warnings, id: \.self) { each_warning in
                            Text(each_warning)
                                .foregroundColor(.sensiBlack)
                        }.onDelete { indexSet in
                            menuItemStore.warnings.remove(atOffsets: indexSet)
                            Task {
                                try await menuItemStore.saveWarnings()
                            }
                        }
                    }
                }
                
                Button {
                    showAddNewWarningView = true
                } label: {
                    Text("Add New Warning")
                }
                
                
            }.navigationTitle("Edit Warnings")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }.sheet(isPresented: $showAddNewWarningView, content: {
                    AddNewWarningView().environmentObject(menuItemStore)
                })
        }
    }
}

struct WarningsEditorView_Previews: PreviewProvider {
    static var previews: some View {
        WarningsEditorView()
    }
}
