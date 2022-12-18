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
                            switch categoty {
                            case .cafe:
                                Text("Кафе")
                            case .bar:
                                Text("Бары")
                            case .restaurant:
                                Text("Рестораны")
                            case .club:
                                Text("Клубы")
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
                    .background(.ultraThinMaterial)
                    .foregroundColor(.black)
                    .clipShape(Circle())
            }
            Text(menuText)
                .font(.title2)
                .bold()
        }
    }
    
    //MARK: - Private functions
    
    private func filterPlaces() {
        switch selectedCategory {
        case .club:
            filteredPlaces = locations.filter({$0.type == .club})
            menuText = "Клубы"
        case .cafe:
            filteredPlaces = locations.filter({$0.type == .cafe})
            menuText = "Кафе"
        case .bar:
            filteredPlaces = locations.filter({$0.type == .bar})
            menuText = "Бары"
        case .restaurant:
            filteredPlaces = locations.filter({$0.type == .restaurant})
            menuText = "Рестораны"
        case .none:
            filteredPlaces = locations
            menuText = "Все места"
        }
    }
}
