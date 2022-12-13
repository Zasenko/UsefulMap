//
//  UserViewModel.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 01.12.22.
//

import Foundation

class UserViewModel {
    
    //MARK: - Properties
    
    var user = User()
    
    //MARK: - Private properties
    
    private let userMomento = Momento()
    
    //MARK: - Init
    
    init() {
        self.user = self.userMomento.loadUser()
    }
}

extension UserViewModel {
    
    //MARK: - Functions
    
    func saveUser(user: User) {
        userMomento.save(user: user)
        self.user = user
    }
    
    func isUserLoggedIn() -> Bool {
        return user.id != nil
    }
}