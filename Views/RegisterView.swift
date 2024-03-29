//
//  RegisterView.swift
//  orientApp
//
//  Created by Alex Šunjajev on 16.11.2023.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var smanager: Manager
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var password2 = ""
    
    @State private var registerSuccessful = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color
                    .black
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    VStack (spacing: 10){
                        Text("Create account")
                            .font(.title)
                            .padding()
                            .foregroundColor(.white.opacity(0.8))
                        
                        TextField("First Name", text: $firstName)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .border(.red, width: CGFloat(AuthorizationManager.shared.firstNameError ? 3 : 0))
                        
                        
                        TextField("Last Name", text: $lastName)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .border(.red, width: CGFloat(AuthorizationManager.shared.lastNameError ? 3 : 0))
                        
                        
                        TextField("Email", text: $email)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .border(.red, width: CGFloat(AuthorizationManager.shared.emailError ? 3 : 0))
                        
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .border(.red, width: CGFloat(AuthorizationManager.shared.passwordError ? 3 : 0))
                        
                        
                        SecureField("Password again", text: $password2)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                        
                            .border(.red, width: CGFloat(AuthorizationManager.shared.password2Error ? 3 : 0))
                        
                    }
                    
                    Button(action: {
                        Task {
                            await
                            AuthorizationManager.shared.validateAndCreateUser(
                                firstName: firstName,
                                lastName: lastName,
                                email: email,
                                password: password,
                                password2: password2
                            )
                            registerSuccessful = smanager.registerLoading
                            
                        }
                    }
                           
                           ,label: {
                        if smanager.registerLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Create")
                        }
                    })
                    .frame(width: 265)
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white.opacity(0.9))
                    .font(.headline)
                    .cornerRadius(12.0)
                    
                }
                .disabled(smanager.registerLoading)
                .padding(.vertical, 20)
                .frame(maxWidth: 265)
                .padding()
                .foregroundColor(.white.opacity(0.9))
                .font(.headline)
                .cornerRadius(12.0)
                .navigationDestination(
                    isPresented: $registerSuccessful) {
                        LoginView()
                    }
            }
        }
    }
}


#Preview {
    RegisterView()
}


#Preview {
    RegisterView()
}
