//
//  ContentView.swift
//  SecureApp
//
//  Created by Богдан Зыков on 10.01.2022.
//

import SwiftUI

struct ContentView: View {
@EnvironmentObject var authentication: Authentication
    var body: some View {
        NavigationView{
            VStack{
                Text("Autorized.. You are in!")
                    .font(.largeTitle)
                Image("Inside")
            }
            .padding()
            .navigationTitle("My Secure App")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Log out"){
                        authentication.updateValidation(success: false)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Authentication())
    }
}
