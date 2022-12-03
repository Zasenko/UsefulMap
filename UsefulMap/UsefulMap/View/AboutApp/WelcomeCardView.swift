//
//  WelcomeCardView.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 22.11.22.
//

import SwiftUI

struct WelcomeCardView: View {
    
    //MARK: - Properties

    var card: WelcomeCard
    
    //MARK: - Body
    
    var body: some View {
        VStack {
            Image(card.image)
                .resizable()
                .scaledToFit()
                .cornerRadius(20)
                .shadow(radius: 15)
                .padding()
                .padding()
            Text(card.text)
                .font(.title2)
                .monospacedDigit()
                .multilineTextAlignment(.center)
                .padding(.bottom)
            
            if card.id == 3 {
                Button {
                    UserDefaults.standard.set(false, forKey: "isFirstTime")
                } label: {
                    Text("Далее")
                        .foregroundColor(.white)
                        .font(.callout.bold())
                        .padding()
                        .padding(.horizontal)
                        .background(.green)
                        .cornerRadius(10)
                }
            }
            Spacer()
        }//-VStack
        .padding(.horizontal)
        .padding()
    }
}
