//
//  MenuEditorViewBuilder.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 5/07/2022.
//

import SwiftUI



@ViewBuilder func deleteButton(isVisible: Bool, deleteAction: @escaping () -> ()) -> some View {
    if isVisible {
        Button("Delete", role: .destructive, action: deleteAction)
            .frame(maxWidth: .infinity)
    }
}

@ViewBuilder func saveButton(action: @escaping () -> ()) -> some View {
    Button("Save", action: action)
        .frame(maxWidth: .infinity)
}

/// Clickable label that opens `sheet`to view `CategoryPickerView`.
@ViewBuilder func categoryPickerButton(_ catgory: String, onTap: @escaping () -> ()) -> some View {
    Button {
        onTap()
    } label: {
        HStack {
            Text("Category")
                .foregroundStyle(.primary)
            Spacer()
            Text(catgory)
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.caption)
        }
    }
    
}

/// **TextField** where the user can edit or enter new ingredients.
@ViewBuilder func text_field(_ text: Binding<String>) -> some View {
    TextField("Ingredient Name", text: text)
        .submitLabel(.next)
        .autocapitalization(.words)
        .deleteDisabled(text.wrappedValue == "")
}

/// Confirmation dialog actions.
///
/// Actions:
/// - **Keep Editing**
/// - **Save Anyway**
@ViewBuilder func confirmationDialogButtons(forcedAction: @escaping () -> ()) -> some View {
    Button("Keep Editing", role: .cancel) { }
    Button("Save anyway", action: forcedAction)
}



// MARK: enum FocusField
enum FocusField: Hashable {
    case itemName
    case regularIngredients
    case extraIngredients
    case `nil`
}
