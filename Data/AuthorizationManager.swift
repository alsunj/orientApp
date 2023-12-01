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
    static let shared = AuthorizationManager()
    
    static func requestLocationAuthorization() {
        LocationManager.shared.requestLocation()
    }
    static func requestAuthorization(for manager: CLLocationManager) {
        manager.requestWhenInUseAuthorization()
    }
    
    func isEmailValid(_ email: String) -> Bool {
        return email.contains("@")
    }
    func isCredentialValid(_ credential: String) -> Bool {
        return credential.count >= 3
    }
    func isPasswordValid(_ credential: String) -> Bool {
        // Check if the length is at least 8 characters
        guard credential.count >= 8 else {
            return false
        }
        
        // Check if it contains at least 1 uppercase letter
        let uppercaseLetterRegex = ".*[A-Z]+.*"
        guard NSPredicate(format: "SELF MATCHES %@", uppercaseLetterRegex).evaluate(with: credential) else {
            return false
        }
        
        // Check if it contains at least 1 symbol
        let symbolRegex = ".*[^A-Za-z0-9]+.*"
        guard NSPredicate(format: "SELF MATCHES %@", symbolRegex).evaluate(with: credential) else {
            return false
        }
        
        // If all conditions are met, the password is valid
        return true
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
        passwordError = !isPasswordValid(password)
        password2Error = !isPasswordValid(password2) || (password != password2)
        
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
            print("credentials are not valid")
        }
    }
    
    
    
    
}
