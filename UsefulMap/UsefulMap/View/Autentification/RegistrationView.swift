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
    
    @Binding var isRegistrationViewOpen: Bool
    
    @State private var email = ""
    @State private var password = ""
    @State private var error = ""
    
    //MARK: - Body
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    isRegistrationViewOpen = false
                } label: {
                    Text("Close")
                }
            }
            Text(error)
                .frame(height: 100)
            Group {
                TextField("email", text: $email)
                SecureField("password", text: $password)
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal, 40)
            
            Button {
                //запрос в сеть
                isRegistrationViewOpen = false
            } label: {
                Text("Регистрация")
                    .foregroundColor(.white)
                    .font(.callout.bold())
                    .padding(10)
                    .padding(.horizontal)
                    .background(.green)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .background(Image("map").blur(radius: 50))
    }
}
