//
//  LoginViewModel.swift
//  SecureApp
//
//  Created by Богдан Зыков on 10.01.2022.
//

import Foundation

class LoginViewModel: ObservableObject{
    
    @Published var user = User()
    @Published var showProgressView = false
    @Published var error: Authentication.AuthenticationError?
    @Published var storeUserNext = false
    
    var loginDisabled: Bool {
        user.email.isEmpty || user.password.isEmpty
    }
    
    func login(completion: @escaping (Bool) -> Void) {
        showProgressView = true
        TestApiService.shared.login(user: user) { [unowned self](result:Result<Bool, Authentication.AuthenticationError>) in
         showProgressView = false
            switch result {
            case .success:
                if storeUserNext {
                    if KeychainStorage.saveUser(user) {
                        storeUserNext = false
                    }
                }
                completion(true)
            case .failure(let authError):
                user = User()
                error = authError
                completion(false)
            }
        }
    }
}
