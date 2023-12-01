//
//  LoginOrRegisterView.swift
//  orientApp
//
//  Created by Alex Šunjajev on 16.11.2023.
//

import SwiftUI

struct LoginOrRegisterView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color
                    .black
                    .ignoresSafeArea()
                
                
                VStack(spacing: 15) {
                    Text("Sign in or Create account:")
                        .font(.title)
                        .padding()
                        .foregroundColor(.white.opacity(0.8))
                    
                    NavigationLink (destination: LoginView()) {
                        Text("Sign in")
                            .frame(maxWidth: 300)
                            .padding()
                            .background(.blue)
                            .foregroundColor(.white.opacity(0.9))
                            .font(.headline)
                            .cornerRadius(12.0)
                    }
                    
                    NavigationLink {
                        RegisterView()
                    } label: {
                        Text("Create account")
                            .frame(maxWidth: 300)
                            .padding()
                            .background(.blue)
                            .foregroundColor(.white.opacity(0.9))
                            .font(.headline)
                            .cornerRadius(12.0)
                    }
                }
            }
        }
    }
}

#Preview {
    LoginOrRegisterView()
}
