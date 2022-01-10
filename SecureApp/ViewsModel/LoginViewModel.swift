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
    @Published var error:Authentication.AuthenticationError?
    var showAlert = false
    
    var loginDisabled: Bool{
        user.email.isEmpty || user.email.isEmpty
    }
    func login(completion: @escaping (Bool) -> Void ){
        showProgressView = true
        TestApiService.shared.login(user: user) { [unowned self](result: Result<Bool, Authentication.AuthenticationError>) in
            showProgressView = false
            switch result{
            case .success:
                completion(true)
            case .failure(let aufError):
                showAlert.toggle()
                error = aufError
                completion(false)
            }
        }
    }
}
