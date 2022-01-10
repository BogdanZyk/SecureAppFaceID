//
//  TestApi.swift
//  SecureApp
//
//  Created by Богдан Зыков on 10.01.2022.
//

import Foundation

class TestApiService {
    static let shared = TestApiService()

        func login(user: User,
                   completion: @escaping (Result<Bool,Authentication.AuthenticationError>) -> Void) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if user.password == "password" {
                    completion(.success(true))
                } else {
                    completion(.failure(.invalidCredentials))
                }
            }
        }
    }

