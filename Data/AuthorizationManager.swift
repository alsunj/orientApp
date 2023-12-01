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
    var loginSuccessful = false
    
    
    
    
    
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
        password2: String
    ) async {
        firstNameError = !isCredentialValid(firstName)
        lastNameError = !isCredentialValid(lastName)
        emailError = !isEmailValid(email)
        passwordError = !isCredentialValid(password)
        password2Error = !isCredentialValid(password2) || (password != password2)
        
        let isValid = !firstNameError && !lastNameError && !emailError && !passwordError && !password2Error
        if isValid {await Manager.shared.register(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password)
            
        }
        else {
        }
        
    }
    func validateAndLogin(
        email: String,
        password: String
    ) async{
        // Validation logic for email and password
        emailError = !isEmailValid(email)
        passwordError = !isCredentialValid(password)
        let isValid = !emailError && !passwordError
        
        if isValid {
            await Manager.shared.login(email: email, password: password)
            
        }
        
        else {
        }
    }
        
        
        
        
        func reset() {
            
        }
        func pause()
        {
            
        }
        
    
}
