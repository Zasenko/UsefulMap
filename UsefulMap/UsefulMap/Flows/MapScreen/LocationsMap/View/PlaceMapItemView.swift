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
                .cornerRadius(20)
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    if place.isLiked {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.red)
                    }
                    VStack(alignment: .leading) {
                        Text(place.name)
                            .font(.headline)
                        if let lableString = StaticViewsHelper().categoryName[place.type] {
                            Text(lableString)
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                    }
                }
                .padding(.bottom, 4)
                Text(place.address)
                    .font(.subheadline)
                    .lineLimit(1)
                if let distance = place.distance {
                    Group {
                        Text("Дистанция: ") + Text(String(format:"%.1f", distance)) + Text(" км.")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }//-VStack
            .multilineTextAlignment(.leading)
            .foregroundColor(.black)
            .padding(.leading, 10)
            Spacer(minLength: 4)
            Image(systemName: "chevron.right")
                .padding(.trailing, 8)
                .foregroundColor(.black)
                .bold()
        }//-HStack
    }
}
