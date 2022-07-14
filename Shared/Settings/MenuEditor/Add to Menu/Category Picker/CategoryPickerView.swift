//
//  CategoryPickerView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 28/06/2022.
//

import SwiftUI

struct CategoryPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var menuItemStore: MenuItemStore
    
    // This variable is received from ancestor view.
    @Binding var selection: String
    
    @State private var showAddNewCategoryView = false
    
    var body: some View {
        NavigationView {
            Form {
                if menuItemStore.categories.count > 0 {
                    Section {
                        ForEach(menuItemStore.categories, id: \.self) { each_category in
                            Button {
                                selection = each_category
                                dismiss()
                            } label: {
                                HStack {
                                    Text(each_category)
                                        .foregroundStyle(.primary)
                                    Spacer()
                                    Image(systemName: "checkmark")
                                        .opacity(selection == each_category ? 1 : 0)
                                }
                            }
                        }.onDelete { indexSet in
                            // Over here, it is being checked that if the item that is deleted is the same
                            // as the selection. If that is the case, selection is set to an empty string hence
                            // preventing exit from the view and forcing the user to set a category for the item.
                            let tempList = menuItemStore.categories
                            menuItemStore.categories.remove(atOffsets: indexSet)
                            
                            tempList.forEach { each_temp_category in
                                if !menuItemStore.categories.contains(each_temp_category) {
                                    if selection == each_temp_category {
                                        selection = ""
                                    }
                                }
                            }
                        }
                    }
                }
                
                Button {
                    showAddNewCategoryView = true
                } label: {
                    Text("Add New Category")
                }
                
                
            }.navigationTitle("Pick Category")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            dismiss()
                        }.disabled(selection.isEmpty)
                    }
                }.sheet(isPresented: $showAddNewCategoryView, content: {
                    AddNewCategoryView().environmentObject(menuItemStore)
                })
                .interactiveDismissDisabled(selection.isEmpty)
        }
    }
}

struct CategoryPickerView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryPickerView(selection: .constant(""))
            .environmentObject(MenuItemStore())
    }
}
