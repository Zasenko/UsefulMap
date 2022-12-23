//
//  SortingMenu.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 17.12.22.
//

import SwiftUI

struct SortingMenu: View {
    
    //MARK: - Properties
    
    @Binding var placeCategories: [PlaceType]
    @Binding var selectedCategory: PlaceType?
    @Binding var filteredPlaces: Places
    @Binding var locations: Places
    @State private var menuText: String = "Все места"
    
    //MARK: - Body
    
    var body: some View {
        HStack {
            Menu {
                ForEach(placeCategories, id: \.self) { categoty in
                    if selectedCategory != categoty {
                        Button {
                            self.selectedCategory = categoty
                            filterPlaces()
                        } label: {
                            if let lableString = StaticViewsHelper().categoryMap[categoty] {
                                Text(lableString)
                            }
                        }
                    }
                }
                if selectedCategory != nil {
                    Button("Все места") {
                        selectedCategory = nil
                        filterPlaces()
                    }
                }
            } label: {
                Image(systemName: "line.3.horizontal.decrease")
                    .bold()
                    .padding()
                    .background(.thickMaterial)
                    .foregroundColor(.black)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            Text(menuText)
                .font(.title2)
                .bold()
        }
    }
    
    //MARK: - Private functions
    
    private func filterPlaces() {
        let helper = StaticViewsHelper().categoryMap
        
        if let strongSelectedCategory = selectedCategory,
           let strongMenuText = helper[strongSelectedCategory] {
            filteredPlaces = locations.filter({$0.type == strongSelectedCategory})
            menuText = strongMenuText
        } else {
            filteredPlaces = locations
            menuText = "Все места"
        }
    }
}
