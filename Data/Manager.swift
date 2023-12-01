//
//  Manager.swift
//  orientApp
//
//  Created by Alex Šunjajev on 29.11.2023.
//

import Foundation

class Manager : NSObject, ObservableObject {

    static let shared = Manager()
    @Published var usertoken: String?
    @Published var sessionStarted: Bool = false
    @Published var sessionLoading = false
    @Published var loginLoading = false
    @Published var registerLoading = false
    @Published var currentUser: User?

    
    func register(firstName: String, lastName: String, email: String, password: String) async {Task {
        registerLoading = true
        let registerStarted = await NetworkManager.shared.register(firstName: firstName, lastName: lastName, email: email, password: password)
        if registerStarted {
            print("Session started successfully")
        } else {
            print("Failed to start the session")

        }
        registerLoading = false

    }}
    
    func login(email: String, password: String) {
        loginLoading = true

        Task {
            
            do {
                let user = await NetworkManager.shared.login(email: email, password: password)
                DispatchQueue.main.async {
                    self.currentUser = user
                }
            } catch {
                print("Login error: \(error)")

            }
            loginLoading = false
        }
    }


        
    func createSession(name: String, description: String, mode: NetworkManager.GpsSessionType) async {Task {
        sessionLoading = true
        let sessionStarted = await NetworkManager.shared.createSession(name: "SessionName", description: "SessionDescription", mode: .walking)
        if sessionStarted {
            print("Session started successfully")
            sessionLoading = false
        } else {
            print("Failed to start the session")
            sessionLoading = false

        }
    
    }
        
        
        
    }
        func saveUserToUserDefaults(user: User, forKey key: String) {
            currentUser = user
            if let encodedUser = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(encodedUser, forKey: key)
            }
        }

    func logout(){
        currentUser = nil
        
    }

    func resetAllManagers() {
        LocationManager.shared.reset()
        CompassManager.shared.reset()
        AuthorizationManager.shared.reset()
        NotificationManager.shared.reset()
    }
    func pauseAllManagers(){
        LocationManager.shared.pause()
        CompassManager.shared.pause()
        AuthorizationManager.shared.pause()
        NotificationManager.shared.pause()
    }
}

