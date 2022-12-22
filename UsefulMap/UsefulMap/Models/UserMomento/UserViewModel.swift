//
//  UserViewModel.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 01.12.22.
//

import Foundation

class UserViewModel {
    
    //MARK: - Private properties
    
    private let userMomento = Momento()
    
    private(set) var user: User {
        didSet {
            userMomento.save(user: self.user)
        }
    }
    
    //MARK: - Init
    
    private init() {
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
