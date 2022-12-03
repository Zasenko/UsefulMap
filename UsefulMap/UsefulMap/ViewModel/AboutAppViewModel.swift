//
//  AboutAppViewModel.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 22.11.22.
//

import Foundation

class AboutAppViewModel {
    
    var cards: [WelcomeCard] = [
        WelcomeCard(id: 1, image: "hiOne", text: "Посмотри ближайшие места рядом с тобой."),
        WelcomeCard(id: 2, image: "hiTwo", text: "Добавь любимые локации в избранное."),
        WelcomeCard(id: 3, image: "hiThree", text: "Посмотри отзывы других пользователей и добавляй свои.")
    ]
}
