//
//  SettingsView.swift
//  orientApp
//
//  Created by Alex Šunjajev on 28.11.2023.
//

import SwiftUI

struct SettingsView: View {
    private var user = Manager.shared.currentUser
    @State private var isSessionCreationSheetPresented = false
    @State private var isConfirmationAlertPresented = false
    @State private var loggedout = false;

    var userDisplay: String {
        if let user = Manager.shared.getUserFromUserDefaults(),
           let firstName = user.firstName,
           let lastName = user.lastName {
            return "\(firstName) \(lastName)"
        } else {
            return "Unknown User" // or any default value you prefer
        }
    }
    
    var body: some View {
           NavigationStack {
               ZStack {
                   Color.black
                       .ignoresSafeArea()
                   VStack(spacing: 15) {
                       Text("Hello, \(userDisplay)")
                           .foregroundColor(.white)
                           .font(.headline)
                       Text("Settings:")
                           .font(.title)
                           .padding()
                           .foregroundColor(.white.opacity(0.8))
                       Button(action: {
                           if Manager.shared.sessionStarted {
                               isConfirmationAlertPresented.toggle()
                           } else {
                               isSessionCreationSheetPresented.toggle()
                           }
                       }) {
                           Text("Create Session")
                       }
                       .buttonStyle(MainButtonStyle())
                       Button(action: {
                           Task { loggedout = true }
                       }) {
                           Text("Log Out")
                       }
                       .buttonStyle(LogOutButtonStyle())
                       .sheet(isPresented: $isSessionCreationSheetPresented) {
                           SessionCreationView(isPresented: $isSessionCreationSheetPresented)
                       }
                       NavigationLink(destination: SessionsView()) {
                           Text("View Sessions")
                               .buttonStyle(MainButtonStyle())
                       }
                   }
               }
           }
       

       // ... (existing code)
   }

   struct MainButtonStyle: ButtonStyle {
       func makeBody(configuration: Configuration) -> some View {
           configuration.label
               .frame(maxWidth: 300)
               .padding()
               .background(Color.blue)
               .foregroundColor(.white.opacity(0.9))
               .font(.headline)
               .cornerRadius(12.0)
               .opacity(configuration.isPressed ? 0.8 : 1.0)
       }
   }

   struct LogOutButtonStyle: ButtonStyle {
       func makeBody(configuration: Configuration) -> some View {
           configuration.label
               .frame(maxWidth: 300)
               .padding()
               .background(Color.red)
               .foregroundColor(.white.opacity(0.9))
               .font(.headline)
               .cornerRadius(12.0)
               .opacity(configuration.isPressed ? 0.8 : 1.0)
       }
   }
    
    struct SessionCreationView: View {
        @Binding var isPresented: Bool
        @State private var sessionName: String = ""
        @State private var description: String = ""
        @State private var isWalkingSelected: Bool = true
        
        var body: some View {
            VStack {
                Text("Session Details")
                    .font(.headline)
                    .padding()
                TextField("Session name",text: $sessionName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                
                TextField("Description", text: $description)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                
                HStack {
                    Image(systemName: isWalkingSelected ? "figure.run" : "figure.walk")
                    Toggle(isOn: $isWalkingSelected) {
                        Text(isWalkingSelected ? "Running" : "Walking")
                    }
                    .labelsHidden()
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(8)
                Button(action: {
                    Task {
                        await NetworkManager.shared.createSession(
                            name: sessionName,
                            description: description,
                            mode: isWalkingSelected ? .walking : .running
                        )
                    }
                }, label: {
                    if Manager.shared.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Create")
                    }
                })
                .padding()
                
            }
            
        }
    }
    
    
    
}
