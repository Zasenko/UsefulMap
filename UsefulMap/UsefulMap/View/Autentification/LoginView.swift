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
    
    @Binding var isLocationViewOpen: Bool
    
    @State private var login = ""
    @State private var password = ""
    @State private var error = ""
    @State private var isRegistrationViewOpen: Bool = false
    
    //MARK: - Body
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            Text("UsefulMap")
                .bold()
                .font(.title3)
            Text(error)
                .bold()
                .font(.headline)
                .frame(height: 70)
            Group {
                TextField("email", text: $login)
                SecureField("password", text: $password)
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal, 40)
            HStack {
                Button {
                    isRegistrationViewOpen = true
                } label: {
                    Text("Регистрация")
                        .foregroundColor(.white)
                        .font(.callout.bold())
                        .padding(10)
                        .padding(.horizontal)
                        .background(.green)
                        .cornerRadius(10)
                }
                Button {
                    Task {
                        await login(login: login, password: password)
                        isLocationViewOpen = userViewModel.isUserLoggedIn()
                    }
                } label: {
                    Text("Войти")
                        .foregroundColor(.white)
                        .font(.callout.bold())
                        .padding(10)
                        .padding(.horizontal)
                        .background(.green)
                        .cornerRadius(10)
                }
            }//-HStack
            .padding()
            Button {
                isLocationViewOpen = true
            } label: {
                Text("попустить")
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
            RegistrationView(networkManager: networkManager, isRegistrationViewOpen: $isRegistrationViewOpen)
        }
    }
    
    @MainActor
    func login(login: String, password: String) async {
        do {
            let loginResult = try await networkManager.login(login: login, password: password)
            if loginResult.result == 0 {
                error = loginResult.error ?? ""
            } else {
                guard let user = loginResult.user else {return}
                userViewModel.saveUser(user: user)
            }
        } catch {
            print("Error:---", error)
        }
    }
}
//
//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}
