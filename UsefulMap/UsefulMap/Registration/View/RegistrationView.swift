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
    
    @ObservedObject var registrationViewModel = RegistrationViewModel()
    @Binding var isLocationViewOpen: Bool
    @Binding var isRegistrationViewOpen: Bool
    
    //MARK: - Body
    
    var body: some View {
        VStack {
            LogoSubView()
            Spacer().frame(height: 50)
            Text(registrationViewModel.error)
                .foregroundColor(.red)
                .bold()
                .multilineTextAlignment(.center)
                .font(.headline)
                .frame(width: screeenWidth/1.5, height: 70)
            Group {
                TextField("Email", text: $registrationViewModel.login, onEditingChanged: {_ in registrationViewModel.error = ""})
                SecureField("Password", text: $registrationViewModel.password)
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal, 40)
            
            Button {
                Task {
                    await registrationViewModel.registration(networkManager: networkManager, userViewModel: userViewModel)
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
}
