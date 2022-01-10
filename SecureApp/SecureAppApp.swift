//
//  SecureAppApp.swift
//  SecureApp
//
//  Created by Богдан Зыков on 10.01.2022.
//

import SwiftUI

@main
struct SecureAppApp: App {
@StateObject var authentication = Authentication()
    var body: some Scene {
        WindowGroup {
            Group{
                if authentication.isValidated{
                    ContentView()
                        .environmentObject(authentication)
                }else{
                    LoginView()
                        .environmentObject(authentication)
                }
            }
        }
    }
}
