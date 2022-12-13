//
//  AboutAppView.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 22.11.22.
//

import SwiftUI

struct AboutAppView: View {
    
    //MARK: - Properties

    var viewModel = AboutAppViewModel()
        
    //MARK: - Body

    var body: some View {
        VStack {
            LogoSubView()
            TabView {
                WelcomeCardView(card: viewModel.cards[0])
                    .tag(0)
                WelcomeCardView(card: viewModel.cards[1])
                    .tag(1)
                WelcomeCardView(card: viewModel.cards[2])
                    .tag(2)
            }
            .padding()
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
        }//-VStack
        .background(AppImages.mapBackground.blur(radius: 50))
    }
}
