//
//  LoginView.swift
//  SecureApp
//
//  Created by Богдан Зыков on 10.01.2022.
//

import SwiftUI

struct LoginView: View {
@StateObject private var loginVM = LoginViewModel()
@EnvironmentObject var authentication: Authentication
    var body: some View {
        VStack{
            Text("My Secure App")
                .font(.largeTitle)
            TextField("Email Address", text: $loginVM.user.email)
                .keyboardType(.emailAddress)
            SecureField("Password", text: $loginVM.user.password)
            if loginVM.showProgressView{
                ProgressView()
            }
            Button("Log in"){
                loginVM.login { success in
                    authentication.updateValidation(success: success)
                }
            }
            .disabled(loginVM.loginDisabled)
            .padding()
            Image("LaunchScreen")
//                .onTapGesture {
//                    UIApplication.shared.endEditing()
//                }
            Spacer()
        }
        .textInputAutocapitalization(.none)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
        .disabled(loginVM.showProgressView)
        .alert("Invalid Login", isPresented: $loginVM.showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(loginVM.error?.localizedDescription ?? "")
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
