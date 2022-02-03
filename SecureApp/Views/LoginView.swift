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
        VStack {
            Text("My Secure App")
                .font(.largeTitle)
            TextField("Email Address", text: $loginVM.user.email)
                .keyboardType(.emailAddress)
            SecureField("Password", text: $loginVM.user.password)
            if loginVM.showProgressView {
                ProgressView()
            }
            Button("Log in") {
                loginVM.login { success in
                    authentication.updateValidation(success: success)
                }
            }
            .disabled(loginVM.loginDisabled)
            .padding(.bottom,20)
            if authentication.biometricType() != .none {
                Button {
                    authentication.requestBiometricUnlock { (result:Result<User, Authentication.AuthenticationError>) in
                        switch result {
                        case .success(let user):
                            loginVM.user = user
                            loginVM.login { success in
                                authentication.updateValidation(success: success)
                            }
                        case .failure(let error):
                            loginVM.error = error
                        }
                    }
                } label: {
                    Image(systemName: authentication.biometricType() == .face ? "faceid" : "touchid")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
            }
            Image("LaunchScreen")
//                .onTapGesture {
//                    UIApplication.shared.endEditing()
//                }
            Spacer()
        }
        .autocapitalization(.none)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
        //.disabled(loginVM.showProgressView)
        .alert(item: $loginVM.error) { error in
            if error == .userNotSaved {
                return Alert(title: Text("User Not Saved"),
                             message: Text(error.localizedDescription),
                             primaryButton: .default(Text("OK"), action: {
                    loginVM.storeUserNext = true
                             }),
                             secondaryButton: .cancel())
            } else {
                return Alert(title: Text("Invalid Login"), message: Text(error.localizedDescription))
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(Authentication())
    }
}
