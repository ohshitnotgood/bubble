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
    
    @Binding var selection: String
    
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
                                        .foregroundColor(.sensiBlack)
                                    Spacer()
                                    Image(systemName: "checkmark")
                                        .opacity(selection == each_category ? 1 : 0)
                                }
                            }.swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button("Delete") {
                                    if selection == each_category {
                                        selection = ""
                                    }
                                    if let index = menuItemStore.categories.firstIndex(of: each_category) {
                                        menuItemStore.categories.remove(at: index)
                                    }
                                }.tint(.red)
                            }
                        }
                    } header: {
                        Text("Pick category")
                    }
                }
                
                NavigationLink {
                    AddNewCategoryView().environmentObject(menuItemStore)
                } label: {
                    Text("Add New Category")
                }.foregroundColor(.accentColor)
                
                
            }.navigationTitle("Pick Category")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
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
