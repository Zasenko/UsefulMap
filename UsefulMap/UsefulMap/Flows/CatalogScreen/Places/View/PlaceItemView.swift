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
            }//-VStack
            .multilineTextAlignment(.leading)
            .foregroundColor(.black)
            Spacer()
        }//-HStack
    }
}
