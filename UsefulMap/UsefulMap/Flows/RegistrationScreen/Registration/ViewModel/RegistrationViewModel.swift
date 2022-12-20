//
//  RegistrationViewModel.swift
//  UsefulMap
//
//  Created by Eduard on 12.12.2022.
//

import  SwiftUI

class RegistrationViewModel: ObservableObject {
    
    //MARK: - Properties
    
    let networkManager: NetworkManager
    let userViewModel: UserViewModel
    
    @Published var login = ""
    @Published var password = ""
    @Published var error = ""
    
    @Binding var isLocationViewOpen: Bool
    @Binding var isRegistrationViewOpen: Bool
    
    //MARK: - Initialization
    
    init(networkManager: NetworkManager, userViewModel: UserViewModel, isLocationViewOpen: Binding<Bool>, isRegistrationViewOpen: Binding<Bool>) {
        self.networkManager = networkManager
        self.userViewModel = userViewModel
        _isLocationViewOpen = isLocationViewOpen
        _isRegistrationViewOpen = isRegistrationViewOpen
    }
}

extension RegistrationViewModel {
    
    //MARK: - Functions
    
    @MainActor
    func registration() async {
        if isFieldsTextCorrect() {
            do {
                let registrationResult = try await networkManager.registration(login: login, password: password)
                if registrationResult.result == 0 {
                    error = registrationResult.error ?? ""
                    self.login = ""
                    self.password = ""
                } else {
                    guard let shorthandUser = registrationResult.user else {
                        return
                    }
                    userViewModel.saveUser(user: shorthandUser)
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
