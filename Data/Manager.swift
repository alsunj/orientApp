//
//  Manager.swift
//  orientApp
//
//  Created by Alex Šunjajev on 29.11.2023.
//

import Foundation

class Manager {
    static let shared = Manager()
    private var authToken: String? // Variable to store the authentication token
      func getAuthToken() -> String? {
          return authToken
      }
    
    func registerUser(
            firstName: String,
            lastName: String,
            email: String,
            password: String,
            completion: @escaping (Result<String, Error>) -> Void
        ) {
            let user = User(firstName: firstName, lastName: lastName, email: email, password: password)
            NetworkManager.shared.registerUser(user: user, completion: completion)
        }
    
    func loginUser(
           email: String,
           password: String,
           completion: @escaping (Result<String, Error>) -> Void
       ) {
           let credentials = LoginUser(email: email, password: password)
           NetworkManager.shared.loginUser(credentials: credentials) { [weak self] result in
               switch result {
               case .success(let token):
                   // Store the token
                   self?.authToken = token
                   completion(.success(token))
               case .failure(let error):
                   completion(.failure(error))
               }
           }
       }
    
    func startNewSession(session: Session, completion: @escaping (Result<Session, Error>) -> Void) {
        NetworkManager.shared.startNewSession(session: session, completion: completion)
    }
    
    func getLocationTypes(completion: @escaping (Result<[Location], Error>) -> Void) {
        NetworkManager.shared.getLocationTypes(completion: completion)
    }
    
    func postLocationUpdate(location: Location, completion: @escaping (Result<Void, Error>) -> Void) {
        NetworkManager.shared.postLocationUpdate(location: location, completion: completion)
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
struct LoginUser {
    var email: String
    var password: String
}
