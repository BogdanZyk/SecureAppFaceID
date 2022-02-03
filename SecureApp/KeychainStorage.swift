//
//  KeychainStorage.swift
//  SecureApp
//
//  Created by Богдан Зыков on 10.01.2022.
//


import Foundation
import SwiftKeychainWrapper

enum KeychainStorage {
    static let key = "user"
    
    static func getuser() -> User? {
        if let myUserString = KeychainWrapper.standard.string(forKey: Self.key) {
            return User.decode(myUserString)
        } else {
            return nil
        }
    }
    
    static func saveUser(_ user: User) -> Bool {
        if KeychainWrapper.standard.set(user.encoded(), forKey: Self.key) {
            return true
        } else {
            return false
        }
    }
}
