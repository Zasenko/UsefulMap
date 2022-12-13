//
//  LoginViewModel.swift
//  UsefulMap
//
//  Created by Eduard on 11.12.2022.
//

import  SwiftUI

class LoginViewModel: ObservableObject {
    
    //MARK: - Properties
    
    let userViewModel: UserViewModel
    let networkManager: NetworkManager
    
    @Published var login = ""
    @Published var password = ""
    @Published var error = ""
    @Published var isRegistrationViewOpen: Bool = false
    
    @Binding var isLocationViewOpen: Bool
    
    //MARK: - Initialization
    
    init(userViewModel: UserViewModel, networkManager: NetworkManager, isLocationViewOpen: Binding<Bool>) {
        self.userViewModel = userViewModel
        self.networkManager = networkManager
        self._isLocationViewOpen = isLocationViewOpen
    }
}

extension LoginViewModel {
    
    //MARK: - Functions
    
    @MainActor
    func login() async {
        if isFieldsTextCorrect() {
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
    
    //MARK: - Private Functions
    
    private func isFieldsTextCorrect() -> Bool {
        guard login.count > 0 else {
            error = "Введите email!"
            clearFields()
            return false
        }
        guard login.contains("@") else {
            error = "Вы не ввели email!"
            clearFields()
            return false
        }
        guard password.count > 0 else {
            error = "Введите пароль. Пароль должен содержать буквы и цифры!"
            clearFields()
            return false
        }
        guard password.filter({!("1"..."9" ~= $0)}).count != 0 else {
            error = "Введите пароль. Пароль должен содержать буквы и цифры!"
            clearFields()
            return false
        }
        return true
    }
    
    private func clearFields() {
        login = ""
        password = ""
    }
}
