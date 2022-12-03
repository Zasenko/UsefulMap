//
//  PlaceItemView.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 29.11.22.
//

import SwiftUI

struct PlaceItemView: View  {
    
    //MARK: - Properties
    
    let place: DecodedPlace
    
    //MARK: - Body

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: place.photo)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .cornerRadius(10)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 100)
            VStack(alignment: .leading) {
                Text(place.name)
                    .bold()
                Text(place.type.rawValue)
                Text(place.address)
                if let distance = place.distance {
                    Text("Дистанция: ") + Text(String(distance))
                }
            }//-VStack
            Spacer()
        }//-HStack
    }
}
