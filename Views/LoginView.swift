//
//  LoginView.swift
//  orientApp
//
//  Created by Alex Šunjajev on 16.11.2023.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var smanager: Manager

    @State private var email = ""
    @State private var password = ""
    
    @State private var usernameError: Float = 0
    @State private var passwordError: Float = 0
    @State private var loginSuccessful = false;

    var body: some View {
        NavigationStack {
            ZStack {
                Color
                    .black
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    VStack {
                        Text("Login")
                            .font(.title)
                            .padding()
                            .foregroundColor(.white.opacity(0.8))
                        
                        TextField("Username", text: $email)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .border(.red, width: CGFloat(usernameError))
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .border(.red, width: CGFloat(passwordError))
                    }
                    
                    Button(action: {
                        Task {
                            await
                            AuthorizationManager.shared.validateAndLogin(
                                email: email,
                                password: password
                            )
                            loginSuccessful = Manager.shared.loginLoading
                        }
                    }
                           ,label: {
                        if smanager.loginLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Login")
                        }
                    })
                    
                    .disabled(smanager.loginLoading)
                    .frame(maxWidth: 265)
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white.opacity(0.9))
                    .font(.headline)
                    .cornerRadius(12.0)
                    .navigationDestination(
                        isPresented: $loginSuccessful) {
                            MapView()
                                .navigationBarHidden(true)

                        }
                    
                }
                }
            }
        }
    }


#Preview {
    LoginView()
}
