//
//  PlaceItemView.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 29.11.22.
//

import SwiftUI

struct PlaceItemView: View  {
    
    //MARK: - Properties
    
    @Binding var place: Place
    
    //MARK: - Body

    var body: some View {
        HStack {
            CachedImageView(viewModel: CachedImageViewModel(url: place.photo))
                .frame(width: 100, height: 100)
                .cornerRadius(10)
                .shadow(radius: 5)
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    if place.isLiked {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.red)
                    }
                    Text(place.name)
                        .font(.headline)
                }
                .padding(.bottom, 4)
                if let lableString = StaticViewsHelper().categoryName[place.type] {
                    Text(lableString)
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                Text(place.address)
                    .font(.subheadline)
            }//-VStack
            .multilineTextAlignment(.leading)
            .foregroundColor(.black)
            .padding(.leading, 10)
        }//-HStack
    }
}
