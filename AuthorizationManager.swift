//
//  AuthorizationManager.swift
//  orientApp
//
//  Created by Alex Šunjajev on 29.11.2023.
//

import Foundation
import CoreLocation

class AuthorizationManager {
    @Published var firstNameError = false
    @Published var lastNameError = false
    @Published var emailError = false
    @Published var passwordError = false
    @Published var password2Error = false
    @Published var registerSuccessful = false
    static let shared = AuthorizationManager()
    
    
    
    
    static func requestLocationAuthorization() {
        LocationManager.shared.requestLocation()
    }
    static func requestAuthorization(for manager: CLLocationManager) {
        manager.requestWhenInUseAuthorization()
    }
    static func requestNotificationAuthorization() {
        // Implement notification authorization logic
    }
    func isEmailValid(_ email: String) -> Bool {
        return email.contains("@")
    }
    func isCredentialValid(_ credential: String) -> Bool {
        return credential.count >= 3
    }
    

    func validateAndCreateUser(
            firstName: String,
            lastName: String,
            email: String,
            password: String,
            password2: String,
            completion: @escaping (Bool) -> Void
        ) {
            firstNameError = !isCredentialValid(firstName)
            lastNameError = !isCredentialValid(lastName)
            emailError = !isEmailValid(email)
            passwordError = !isCredentialValid(password)
            password2Error = !isCredentialValid(password2) || (password != password2)
            
            let isValid = !firstNameError && !lastNameError && !emailError && !passwordError && !password2Error
            if isValid {
                let user = User(userId: UUID(), firstName: firstName, lastName: lastName, email: email, password: password)
                
                NetworkManager.shared.registerUser(user: user) { result in
                    switch result {
                    case .success:
                        // Handle success, e.g., set registerSuccessful flag
                        self.registerSuccessful = true
                        completion(true)
                    case .failure(let error):
                        // Handle failure, e.g., display an error message
                        print("Error registering user: \(error)")
                        completion(false)
                    }
                }
            } else {
                completion(false)
            }
        }
        
        func createUser(username: String, password: String) {
            // Assuming you have some local storage mechanism to store the user locally
            // You can use UserDefaults or CoreData, for example
            // Store the user locally
            // Store the user locally using your preferred storage mechanism
            
            // After storing the user locally, proceed to register the user with the network manager
            
        }
        func reset() {
            
        }
        func pause()
        {
            
        }
    
}
