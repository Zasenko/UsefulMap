//
//  LoginView.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 22.11.22.
//

import SwiftUI

struct LoginView: View {
    
    //MARK: - Properties
    
    let userViewModel: UserViewModel
    let networkManager: NetworkManager
    let screeenWidth = UIScreen.main.bounds.width
    
    @Binding var isLocationViewOpen: Bool
    
    @State private var login = ""
    @State private var password = ""
    @State private var error = ""
    @State private var isRegistrationViewOpen: Bool = false
    
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
            VStack {
                Button {
                    Task {
                        await login(login: login, password: password)
                        isLocationViewOpen = userViewModel.isUserLoggedIn()
                    }
                } label: {
                    Text("Войти")
                        .font(.headline)
                        .frame(width: screeenWidth/2)
                }
                .tint(.green)
                .buttonStyle(.borderedProminent)
                
                Button {
                    isRegistrationViewOpen = true
                } label: {
                    Text("Регистрация")
                        .font(.headline)
                        .frame(width: screeenWidth/2)
                }
                .tint(.green)
                .buttonStyle(.borderedProminent)
                
            }//-VStack with buttons
            .padding()
            Button {
                isLocationViewOpen = true
            } label: {
                Text("Пропустить")
                    .foregroundColor(.gray)
            }
            Spacer()
        }//-VStack
        .onAppear() {
            isLocationViewOpen = userViewModel.isUserLoggedIn()
        }
        .background(
            Image("map")
                .blur(radius: 10)
        )
        .fullScreenCover(isPresented: $isRegistrationViewOpen) {
            isLocationViewOpen = userViewModel.isUserLoggedIn()
        } content: {
            RegistrationView(networkManager: networkManager, userViewModel: userViewModel, isRegistrationViewOpen: $isRegistrationViewOpen, isLocationViewOpen: $isLocationViewOpen)
        }
    }
    
    @MainActor
    func login(login: String, password: String) async {
        do {
            let loginResult = try await networkManager.login(login: login, password: password)
            if loginResult.result == 0 {
                error = loginResult.error ?? ""
                self.login = ""
                self.password = ""
            } else {
                guard let user = loginResult.user else {return}
                userViewModel.saveUser(user: user)
            }
        } catch {
            print("Error:---", error)
        }
    }
}

