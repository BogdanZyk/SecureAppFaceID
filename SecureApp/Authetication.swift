//
//  Authetication.swift
//  SecureApp
//
//  Created by Богдан Зыков on 10.01.2022.
//

import SwiftUI
import LocalAuthentication

class Authentication: ObservableObject {
    @Published var isValidated = false
    @Published var isAutorized = false
    
    enum BiometricType {
        case none
        case face
        case touch
    }
    
    enum AuthenticationError: Error, LocalizedError, Identifiable {
        case invalidCredentials
        case deinedAccess
        case noFaceIdEnrolled
        case noFingerprintEnrolled
        case biometrictError
        case userNotSaved
        
        var id: String {
            self.localizedDescription
        }
        
        var errorDescription: String? {
            switch self {
            case .invalidCredentials:
                return NSLocalizedString("Either your email or password are incorrect. Please try again", comment: "")
            case .deinedAccess:
                return NSLocalizedString("You have denied access. Please go to the settings app and locate this application and turn Face ID on.", comment: "")
            case .noFaceIdEnrolled:
                return NSLocalizedString("You have not registered any Face Ids yet", comment: "")
            case .noFingerprintEnrolled:
                return NSLocalizedString("You have not registered any fingerprints yet.", comment: "")
            case .biometrictError:
                return NSLocalizedString("Your face or fingerprint were not recognized.", comment: "")
            case .userNotSaved:
                return NSLocalizedString("Your account have not been saved. Do you want to save them after the next successful login?", comment: "")
            }
        }
    }
    
    
    func biometricType() -> BiometricType {
        let authContext = LAContext()
            let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch authContext.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touch
            case .faceID:
                return .face
            @unknown default:
                return .none
            }
        }
    
    func updateValidation(success: Bool) {
        withAnimation {
            isValidated = success
        }
    }
    
    func requestBiometricUnlock(completion: @escaping (Result<User, AuthenticationError>) -> Void) {
        //let user: User? = User(email: "test@test.com", password: "password")
        //let user: User? = nil
        let user = KeychainStorage.getuser()
        guard let user = user else{
            completion(.failure(.userNotSaved))
            return
        }
        let context = LAContext()
        var error: NSError?
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        if let error = error {
            switch error.code {
            case -6:
                completion(.failure(.deinedAccess))
            case -7:
                if context.biometryType == .faceID {
                    completion(.failure(.noFaceIdEnrolled))
                } else{
                    completion(.failure(.noFingerprintEnrolled))
                }
            default:
                completion(.failure(.biometrictError))
            }
            return
            
        }
        if canEvaluate {
            if context.biometryType != .none{
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Need to access credentials") {
                    success, error in
                    DispatchQueue.main.async {
                        if error != nil {
                            completion(.failure(.biometrictError))
                        }else{
                            completion(.success(user))
                        }
                    }
                }
            }
        }
    }
}
