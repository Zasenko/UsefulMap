//
//  RegistrationView.swift
//  UsefulMap
//
//  Created by Dmitry Zasenko on 22.11.22.
//

import SwiftUI

struct RegistrationView: View {
    
    //MARK: - Properties

    @StateObject var viewModel: RegistrationViewModel
    
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
                SecureField("Password", text: $viewModel.password)
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal, 40)
            Button {
                Task {
                    await viewModel.registration()
                    if viewModel.userViewModel.isUserLoggedIn() {
                        viewModel.isRegistrationViewOpen = false
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
                viewModel.isRegistrationViewOpen = false
            } label: {
                Text("Отмена")
                    .foregroundColor(.gray)
            }
            Spacer()
        }//-VStack
        .background(AppImages.mapBackground.blur(radius: 50))
    }//-body
}
