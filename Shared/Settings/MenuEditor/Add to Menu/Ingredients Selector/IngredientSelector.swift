//
//  IngredientSelector.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 6/07/2022.
//

import SwiftUI

struct IngredientSelector: View {
    @State private var newIngredientName = ""
    @Environment(\.dismiss) var dismiss
    
    @FocusState var focus: Bool?
    
    var selectedIngredients: Binding<[String]>
    @State var availableIngredients: [String] = []
    
    init(saveSelectedIngredientsIn: Binding<[String]>, loadSavedIngredientsFrom availableIngredients: [String]) {
        selectedIngredients = saveSelectedIngredientsIn
        
        var t = availableIngredients
        selectedIngredients.wrappedValue.forEach { each_ingredient in
            t.removeFirstInstance(of: each_ingredient)
        }
        _availableIngredients = State(initialValue: t)
    }
    
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Type in a new or search for an ingredient...", text: $newIngredientName)
                        .introspectTextField(customize: { tf in
                            tf.becomeFirstResponder()
                        })
                        .textInputAutocapitalization(.words)
                        .focused($focus, equals: true)
                        .submitLabel(newIngredientName.isEmpty ? .done : .next)
                        .onSubmit {
                            withAnimation {
                                selectedIngredients.wrappedValue.appendIfNotContains(newIngredientName)
                                availableIngredients.removeFirstInstance(of: newIngredientName)
                                newIngredientName = ""
                            }
                            focus = true
                        }
                        .onChange(of: newIngredientName) { newValue in
                            
                        }
                } header: {
                    Text("Name")
                }
                
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
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
        }
    }
}

struct IngredientSelector_Previews: PreviewProvider {
    static var previews: some View {
        IngredientSelector(saveSelectedIngredientsIn: .constant([]), loadSavedIngredientsFrom: [])
            .environmentObject(MenuItemStore())
            .navigationTitle("Edit Ingredients")
            .navigationBarTitleDisplayMode(.inline)
        
    }
}
