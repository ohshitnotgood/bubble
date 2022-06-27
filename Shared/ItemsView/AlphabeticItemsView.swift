//
//  AlphabeticItemsView.swift
//  Bubble (iOS)
//
//  Created by Praanto Samadder on 26/06/2022.
//

import SwiftUI

struct AlphabeticItemsView: View {
    // 243, 242, 247
    @State private var searchText: String = ""
    @State private var showCancelButton = false
    
    
    var alphabets: [String] = []
    
    let sortedMenu = menuItems.sorted {
        $0.itemName < $1.itemName
    }
    
    init() {
        for each_item in sortedMenu {
            if let firstChar = each_item.itemName.first {
                if !alphabets.contains(String(firstChar)) {
                    alphabets.append(String(firstChar))
                }
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack (spacing: 0) {
                Divider()
                
                SearchField(text: $searchText)
                    .frame(maxWidth: .infinity)
                    .background(
                        VisualEffectView(.systemThinMaterial)
                    )
                
                LazyVStack (spacing: 0, pinnedViews: .sectionHeaders) {
                    ForEach(alphabets, id: \.self) { alphabet in
                        Section(header: SectionHeader(alphabet), content: {
                            ForEach(sortedMenu.filter { $0.itemName.hasPrefix(alphabet)}, id: \.self) { menuItem in
                                ListItem(menuItem)
                                    .id(menuItem)
                            }
                        }).id(alphabet)
                    }
                }
            }
        }.interactiveDismissDisabled()
    }
}

fileprivate struct ListItem: View {
    private var itemName: String = ""
    private var itemRegularIngredients = ""
    private var itemWarnings: String = ""
    
    
    init(_ menuItem: MenuItem) {
        // MARK: Name
        // Fitting itemName into name
        itemName = menuItem.itemName
        
        
        // MARK: Regular Ingredients
        // Fitting list of regularIngredients into a string
        let itemRegularIngredients = menuItem.regularIngredients
        
        for (idx, each_ingredient) in itemRegularIngredients.enumerated() {
            if idx == itemRegularIngredients.endIndex - 1 {
                self.itemRegularIngredients = self.itemRegularIngredients + "and " + each_ingredient
            } else if idx == itemRegularIngredients.endIndex - 2 {
                self.itemRegularIngredients = self.itemRegularIngredients + each_ingredient + " "
            } else {
                self.itemRegularIngredients = self.itemRegularIngredients + each_ingredient + ", "
            }
        }
        
        // MARK: Warnings
        // Converting list of itemWarnings into a string
        let itemWarnings = menuItem.warnings
        
        for (idx, each_warning) in itemWarnings.enumerated() {
            if idx == itemWarnings.endIndex - 1 {
                self.itemWarnings = self.itemWarnings + "and " + each_warning.rawValue
            } else if idx == itemWarnings.endIndex - 2 {
                self.itemWarnings = self.itemWarnings + each_warning.rawValue + " "
            } else {
                self.itemWarnings = self.itemWarnings + each_warning.rawValue + ", "
            }
        }
        
    }
    
    var body: some View {
        VStack (spacing: 0) {
            HStack {
                Image(systemName: "menucard")
                    .font(.title3)
                    .padding(.trailing, 10)
                
                VStack(alignment: .leading) {
                    Text(itemName)
                        .font(.headline)
                    
                    Text(itemRegularIngredients)
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    
                    Group {
                        Text(Image(systemName: "exclamationmark.circle"))
                        +
                        
                        Text(" Contains ")
                        +
                        
                        Text(self.itemWarnings)
                    }.font(.subheadline)
                        .foregroundColor(.gray)
                }.padding(.vertical, 10)
                
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(.gray)
            }.padding(.horizontal)
            
            Divider()
        }
    }
}

struct AlphabeticItemsView_Previews: PreviewProvider {
    static var previews: some View {
        AlphabeticItemsView()
    }
}
