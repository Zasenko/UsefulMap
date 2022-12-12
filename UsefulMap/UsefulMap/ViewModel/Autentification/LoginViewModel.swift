//
//  LoginViewModel.swift
//  UsefulMap
//
//  Created by Eduard on 11.12.2022.
//

import  SwiftUI

class LoginViewModel: ObservableObject {
    
    //MARK: - Properties
    
    @Published var login = ""
    @Published var password = ""
    @Published var error = ""
    
    //MARK: - Functions
    
    @MainActor
    func login(networkManager: NetworkManager,
               userViewModel: UserViewModel ) async {
        guard login.count > 0, password.count > 0, login.contains("@"), password.filter({!("1"..."9" ~= $0)}).count != 0 else {
            error = "Введите email и пароль. Пароль должен содержать буквы и цифры!"
            login = ""
            password = ""
            return
        }
        do {
            let loginResult = try await networkManager.login(login: login, password: password)
            if loginResult.result == 0 {
                error = loginResult.error ?? ""
                login = ""
                password = ""
            } else {
                guard let user = loginResult.user else {
                    return
                }
                userViewModel.saveUser(user: user)
            }
        } catch {
            print("Error:---", error)
        }
    }
}
