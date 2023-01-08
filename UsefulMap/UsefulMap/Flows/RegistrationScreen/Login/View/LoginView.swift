//
//  LoginView.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 22.11.22.
//

import SwiftUI

struct LoginView: View {
    
    //MARK: - Properties
    
    @StateObject var viewModel: LoginViewModel
    
    //MARK: - Body
    
    var body: some View {
        VStack {
            LogoSubView()
            Spacer().frame(height: 50)
            Text(viewModel.error)
                .foregroundColor(.red)
                .bold()
                .multilineTextAlignment(.center)
                .font(.headline)
                .frame(width: SizesConstants.screeenWidth/1.5, height: 70)
            Group {
                TextField("Email", text: $viewModel.login, onEditingChanged: {_ in viewModel.error = ""})
                    .keyboardType(.emailAddress)
                SecureField("Password", text: $viewModel.password)
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal, 40)
            VStack {
                Button {
                    Task {
                        await viewModel.login()
                        viewModel.isLocationViewOpen = viewModel.userViewModel.isUserLoggedIn()
                    }
                } label: {
                    Text("Войти")
                        .font(.headline)
                        .frame(width: SizesConstants.screeenWidth/2)
                }
                .tint(.green)
                .buttonStyle(.borderedProminent)
                Button {
                    viewModel.isRegistrationViewOpen = true
                } label: {
                    Text("Регистрация")
                        .font(.headline)
                        .frame(width: SizesConstants.screeenWidth/2)
                }
                .tint(.green)
                .buttonStyle(.borderedProminent)
            }//-VStack
            .padding()
            Button {
                viewModel.isLocationViewOpen = true
            } label: {
                Text("Пропустить")
                    .foregroundColor(.gray)
            }
            Spacer()
        }//-VStack
        .onAppear() {
            viewModel.isLocationViewOpen = viewModel.userViewModel.isUserLoggedIn()
        }
        .background(
            AppImages.mapBackground
                .blur(radius: 10)
        )
        .fullScreenCover(isPresented: $viewModel.isRegistrationViewOpen) {
            viewModel.isLocationViewOpen = viewModel.userViewModel.isUserLoggedIn()
        } content: {
            RegistrationView(viewModel: RegistrationViewModel(networkManager: viewModel.networkManager,
                                                              userViewModel: viewModel.userViewModel,
                                                              isLocationViewOpen: $viewModel.isLocationViewOpen,
                                                              isRegistrationViewOpen: $viewModel.isRegistrationViewOpen)
            )
        }
    }
}
