//
//  PlaceMapItemView.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 21.12.22.
//

import SwiftUI

struct PlaceMapItemView: View  {
    
    //MARK: - Properties
    
    @Binding var place: Place
    
    //MARK: - Body

    var body: some View {
        HStack {
            MapImageView(viewModel: CachedImageViewModel(url: place.photo))
                .frame(width: 100, height: 100)
                .cornerRadius(10)
            VStack(alignment: .leading) {
                HStack {
                    if place.isLiked {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.red)
                    }
                    Text(place.name)
                        .bold()
                }
                
                if let lableString = StaticViewsHelper().categoryName[place.type] {
                    Text(lableString)
                        .font(.caption2)
                }
                    
                Text(place.address)
                if let distance = place.distance {
                    Group {
                        Text("Дистанция: ")
                        + Text(String(format:"%.1f", distance))
                    }
                    .font(.caption)
                }
            }//-VStack
            .multilineTextAlignment(.leading)
            .foregroundColor(.black)
            Spacer()
            Image(systemName: "chevron.right")
                .padding()
                .foregroundColor(.black)
                .bold()
        }//-HStack
    }
}
