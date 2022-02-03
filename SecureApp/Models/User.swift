//
//  User.swift
//  SecureApp
//
//  Created by Богдан Зыков on 10.01.2022.
//

import SwiftUI

struct User: Codable {
    var email: String = ""
    var password: String = ""
    
    
    func encoded() -> String {
            let encoder = JSONEncoder()
            let UserData = try! encoder.encode(self)
            return String(data: UserData, encoding: .utf8)!
        }
    
    static func decode(_ userString: String) -> User {
        let decoder = JSONDecoder()
        let jsonData = userString.data(using: .utf8)
        return try! decoder.decode((User.self), from: jsonData!)
    }
}

