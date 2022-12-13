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
    @ObservedObject var loginViewModel = LoginViewModel()
    @Binding var isLocationViewOpen: Bool
    
    //MARK: - Private properties
    
    @State private var isRegistrationViewOpen: Bool = false
    
    //MARK: - Body
    
    var body: some View {
        VStack {
            LogoSubView()
            Spacer().frame(height: 50)
            Text(loginViewModel.error)
                .foregroundColor(.red)
                .bold()
                .multilineTextAlignment(.center)
                .font(.headline)
                .frame(width: screeenWidth/1.5, height: 70)
            Group {
                TextField("Email", text: $loginViewModel.login, onEditingChanged: {_ in loginViewModel.error = ""})
                SecureField("Password", text: $loginViewModel.password)
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal, 40)
            VStack {
                Button {
                    Task {
                        await loginViewModel.login(networkManager: networkManager, userViewModel: userViewModel)
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
            RegistrationView(networkManager: networkManager, userViewModel: userViewModel, isLocationViewOpen: $isLocationViewOpen, isRegistrationViewOpen: $isRegistrationViewOpen)
        }
    }
}

