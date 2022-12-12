//
//  RegistrationViewModel.swift
//  UsefulMap
//
//  Created by Eduard on 12.12.2022.
//

import  SwiftUI

class RegistrationViewModel: ObservableObject {
    
    //MARK: - Properties
    
    @Published var login = ""
    @Published var password = ""
    @Published var error = ""
    
    //MARK: - Functions
    
    @MainActor
    func registration(networkManager: NetworkManager,
               userViewModel: UserViewModel ) async {
        guard login.count > 0, password.count > 0, login.contains("@"), password.filter({!("1"..."9" ~= $0)}).count != 0 else {
            error = "Введите email и пароль. Пароль должен содержать буквы и цифры!"
            login = ""
            password = ""
            return
        }
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
