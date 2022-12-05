//
//  RegistrationView.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 22.11.22.
//

import SwiftUI

struct RegistrationView: View {
    
    //MARK: - Properties
    
    let networkManager: NetworkManager
    let userViewModel: UserViewModel
    
    let screeenWidth = UIScreen.main.bounds.width
    
    @Binding var isRegistrationViewOpen: Bool
    @Binding var isLocationViewOpen: Bool
    
    @State private var login = ""
    @State private var password = ""
    @State private var error = ""
    
    //MARK: - Body
    
    var body: some View {
        VStack {
            LogoSubView()
            Spacer().frame(height: 50)
            Text(error)
                .foregroundColor(.red)
                .bold()
                .multilineTextAlignment(.center)
                .font(.headline)
                .frame(width: screeenWidth/2, height: 70)
            Group {
                TextField("Email", text: $login, onEditingChanged: {_ in error = ""})
                SecureField("Password", text: $password)
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal, 40)
            
            Button {
                Task {
                    await registration(login: login, password: password)
                    if userViewModel.isUserLoggedIn() {
                        isRegistrationViewOpen = false
                        isLocationViewOpen = userViewModel.isUserLoggedIn()
                    }
                }
            } label: {
                Text("Регистрация")
                    .foregroundColor(.white)
                    .font(.callout.bold())
                    .padding(10)
                    .padding(.horizontal)
                    .background(.green)
                    .cornerRadius(10)
            }
            .padding(10)
            Button {
                isRegistrationViewOpen = false
            } label: {
                Text("Отмена")
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .background(Image("map").blur(radius: 50))
    }
    
    
    @MainActor
    func registration(login: String, password: String) async {
        do {
            let registrationResult = try await networkManager.registration(login: login, password: password)
            if registrationResult.result == 0 {
                error = registrationResult.error ?? ""
                self.login = ""
                self.password = ""
            } else {
                guard let shorthandUser = registrationResult.user else {return}
                userViewModel.saveUser(user: shorthandUser)
            }
        } catch {
            print("Error:---", error)
        }
    }
    
}
