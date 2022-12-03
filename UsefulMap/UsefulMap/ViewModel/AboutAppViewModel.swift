//
//  AboutAppViewModel.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 22.11.22.
//

import Foundation

class AboutAppViewModel {
    
    var cards: [WelcomeCard] = [
        WelcomeCard(id: 1, image: "hiOne", text: "Просмотр ближайших от тебя баров, кафе, а также ресторанов"),
        WelcomeCard(id: 2, image: "hiTwo", text: "Добавление любимых локаций в избранное"),
        WelcomeCard(id: 3, image: "hiThree", text: "Просмотр озывов других пользователей, а также добавление своих")
    ]
}
