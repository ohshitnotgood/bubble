//
//  SettingsView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 26/06/2022.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: AddToMenuView()) {
                    Label("Edit Items on Menu...", systemImage: "filemenu.and.selection")
                }.buttonStyle(.plain)
                
                NavigationLink(destination: AddToMenuView()) {
                    Label("Order History", systemImage: "clock.arrow.circlepath")
                }.buttonStyle(.plain)
            }.navigationTitle("Settings")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction, content: {
                        Button("Done") {
                            dismiss()
                        }
                    })
                }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
