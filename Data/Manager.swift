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
    @Published var isLoading = false
    @Published var currentUser: User?
    @Published var currentToken: String?

    


    
    func register(firstName: String, lastName: String, email: String, password: String) async {Task {
        await
        NetworkManager.shared.register(firstName: firstName, lastName: lastName, email: email, password: password)
    }}
    
    func login(email: String, password: String) async {
        do {
            let token = try await NetworkManager.shared.login(email: email, password: password)
            
            // Update UI on the main thread
            Task {
                await MainActor.run {
                    currentToken = token
                }
            }
        } catch {
            // Handle errors, e.g., show an alert or log the error
            print("Error during login: \(error)")
        }
    }


        
    func createSession(name: String, description: String, mode: NetworkManager.GpsSessionType) async {Task{
        await NetworkManager.shared.createSession(name: name, description: description, mode: mode)

    }
        
        
        
    }
        func saveUserToUserDefaults(user: User, forKey key: String) {
            currentUser = user
            if let encodedUser = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(encodedUser, forKey: key)
            }
        }
    func getUserFromUserDefaults() -> User? {
        if let key = currentToken,
            let encodedUser = UserDefaults.standard.data(forKey: key) {
            
            // Dispatch UI-related code to the main thread
            DispatchQueue.main.async {
                if let user = try? JSONDecoder().decode(User.self, from: encodedUser) {
                    // Update the @Published property on the main thread
                    self.currentUser = user
                }
            }
        }
        
        return currentUser
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

