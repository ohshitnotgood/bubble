//
//  IngredientSelector.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 6/07/2022.
//

import SwiftUI

/// Users can edit and pick ingredients to be added to a particular dish.
///
/// Can be used to select ingredients for both the *regular* list and the *extra* list.
///
/// **View Ancestory**
///
/// This view is presented from ``MenuItemEditorView`` as a sheet.
///
/// **View Models**
///
/// This view does not incorporate the use of any view models.
struct IngredientSelector: View {
    @State private var newIngredientName = ""
    @State var ingredientTaken = false
    var pickFor: IngredientListType
    var menuItem: MenuItem
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var menuItemStore: MenuItemStore
    
    @FocusState var focus: Bool?
    
    var selectedIngredients: Binding<[String]>
    
    /// Ingredients that haven't been selected and are available for selection.
    @State var availableIngredients: [String] = []
    
    
    init(saveIn: Binding<[String]>, menuItem: MenuItem, pickFor: IngredientListType) {
        selectedIngredients = saveIn
        self.pickFor = pickFor
        self.menuItem = menuItem
    }
    // Remove selected items from available list
    //        var t = availableIngredients
    //        selectedIngredients.wrappedValue.forEach { each_ingredient in
    //            t.removeFirstInstance(of: each_ingredient)
    //        }
    //        _availableIngredients = State(initialValue: t)
    //    }
    
    private func filterAvailableList() {
        switch pickFor {
            case .regular:
                self.availableIngredients = menuItemStore.ingredients.filter { !menuItem.extraIngredients.contains($0) }
            case .extra:
                self.availableIngredients = menuItemStore.ingredients.filter { !menuItem.regularIngredients.contains($0) }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                // MARK: TextField
                Section {
                    TextField("Type in a new or search for an ingredient...", text: $newIngredientName)
                        .introspectTextField(customize: { tf in
                            tf.becomeFirstResponder()
                        })
                        .textInputAutocapitalization(.words)
                        .focused($focus, equals: true)
                        .submitLabel(newIngredientName.isEmpty ? .done : .next)
                        .onSubmit {
                            if !ingredientTaken {
                                withAnimation {
                                    selectedIngredients.wrappedValue.appendIfNotContains(newIngredientName)
                                    availableIngredients.removeFirstInstance(of: newIngredientName)
                                    newIngredientName = ""
                                }
                                focus = true
                            }
                        }
                        .onChange(of: newIngredientName) { newValue in
                            switch pickFor {
                                case .regular:
                                    ingredientTaken = menuItem.extraIngredients.containsCaseInsensitive(newValue)
                                case .extra:
                                    ingredientTaken = menuItem.regularIngredients.containsCaseInsensitive(newValue)
                            }
                        }
                } header: {
                    Text("Name")
                } footer: {
                    Text("This ingredient has already been added for this item.")
                        .foregroundColor(.red)
                        .opacity(ingredientTaken ? 1 : 0)
                }
                
                // MARK: Selected Ingredients
                if selectedIngredients.count > 0 {
                    Section {
                        ForEach(selectedIngredients.wrappedValue, id: \.self) { ig in
                            Button(ig) {
                                withAnimation {
                                    focus = false
                                    availableIngredients.appendIfNotContains(ig)
                                    selectedIngredients.wrappedValue.removeFirstInstance(of: ig)
                                }
                            }.foregroundColor(.primary)
                        }
                    } header: {
                        Text("Selected ingredients")
                    }
                    
                }
                
                // MARK: Available Ingredients
                if availableIngredients.count > 0 {
                    Section {
                        ForEach(availableIngredients, id: \.self) { ig in
                            Button(ig) {
                                withAnimation {
                                    focus = false
                                    selectedIngredients.wrappedValue.appendIfNotContains(ig)
                                    availableIngredients.removeFirstInstance(of: ig)
                                }
                            }.foregroundColor(.primary)
                        }
                    } header: {
                        Text("Saved Ingredients")
                    }
                }
            }.navigationTitle("Edit Ingredients")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    // MARK: onAppear
                    filterAvailableList()
                    
                }
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            Task {
                                selectedIngredients.forEach {
                                    menuItemStore.ingredients.appendIfNotContains($0.wrappedValue)
                                }
                                availableIngredients.forEach {
                                    menuItemStore.ingredients.appendIfNotContains($0)
                                }
                                try menuItemStore.saveIngredient()
                                dismiss()
                            }
                        }
                    }
                }
        }
    }
}

struct IngredientSelector_Previews: PreviewProvider {
    static var previews: some View {
        IngredientSelector(saveIn: .constant([]), menuItem: MenuItem.pasta, pickFor: .regular)
            .environmentObject(MenuItemStore())
            .navigationTitle("Edit Ingredients")
            .navigationBarTitleDisplayMode(.inline)
        
    }
}

enum IngredientListType {
    case regular
    case extra
}
