//
//  SettingsView.swift
//  orientApp
//
//  Created by Alex Šunjajev on 28.11.2023.
//

import SwiftUI

struct SettingsView: View {
    private var user = Manager.shared.currentUser
    @EnvironmentObject var smanager: Manager
    @State private var isSessionCreationSheetPresented = false
    @State private var isConfirmationAlertPresented = false
    @State private var loggedout = false;
    @State private var resetdata = false;

    var userDisplay: String {
        if let currentUser = Manager.shared.currentUser,
           let firstName = currentUser.firstName,
           let lastName = currentUser.lastName {
            return "\(firstName) \(lastName)"
        } else {
            return "Unknown User"
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
                           Text(Manager.shared.sessionStarted ? "End Session" : "Create Session")
                       }
                       .frame(maxWidth: 300)
                       .padding()
                       .background(smanager.sessionStarted ? .red : .blue)
                       .foregroundColor(.white.opacity(0.9))
                       .font(.headline)
                       .cornerRadius(12.0)

                       NavigationLink(destination: SessionsView()) {
                           Text("View Sessions")
                       }
                       .frame(maxWidth: 300)
                       .padding()
                       .background(Color.blue)
                       .foregroundColor(.white.opacity(0.9))
                       .font(.headline)
                       .cornerRadius(12.0)
                       Button(action: {
                           Task { loggedout = true
                            Manager.shared.logout()}
                       }) {
                           Text("Log Out")
                       }
                       .frame(maxWidth: 300)
                       .padding()
                       .background(Color.red)
                       .foregroundColor(.white.opacity(0.9))
                       .font(.headline)
                       .cornerRadius(12.0)
                       .alert(isPresented: $isConfirmationAlertPresented) {
                           Alert(
                               title: Text("Confirmation"),
                               message: Text("Are you sure you want to stop the session?"),
                               primaryButton: .destructive(Text("Stop Session")) {
                                   Task{ await
                                       Manager.shared.stopSession()
                                   }
                               },
                               secondaryButton: .cancel()
                           )
                       }
                       Button(action: {
                           Task {
                               //    Manager.shared.reset()
                           }
                       }) {
                           Text("Reset")
                       }
                       .frame(maxWidth: 300)
                       .padding()
                       .background(Color.red)
                       .foregroundColor(.white.opacity(0.9))
                       .font(.headline)
                       .cornerRadius(12.0)
                       .navigationDestination(
                           isPresented: $loggedout) {
                               LoginOrRegisterView()
                                   .navigationBarHidden(true)

                           }
                           .sheet(isPresented: $isSessionCreationSheetPresented) {
                               SessionCreationView(isPresented: $isSessionCreationSheetPresented, isSessionCreationSheetPresented: $isSessionCreationSheetPresented)
                                   .environmentObject(smanager)  // Pass the smanager environment object

                           }
                       
                   }
               }
           }
          }

    
    struct SessionCreationView: View {
        @Binding var isPresented: Bool
        @Binding var isSessionCreationSheetPresented: Bool
        @EnvironmentObject var smanager: Manager
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
                        await Manager.shared.createSession(
                            name: sessionName,
                            description: description,
                            mode: isWalkingSelected ? .walking : .running
                        )
                        isSessionCreationSheetPresented = smanager.sessionStarted
                        
                        
                    }
                }, label: {
                    if smanager.sessionLoading {
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

