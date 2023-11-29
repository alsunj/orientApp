//
//  Manager.swift
//  orientApp
//
//  Created by Alex Šunjajev on 29.11.2023.
//

import Foundation

class Manager {
    static let shared = Manager()
    
    
    func registerUser(user: User, completion: @escaping (Result<String, Error>) -> Void) {
        NetworkManager.shared.registerUser(user: user, completion: completion)
    }
    
    func loginUser(user: User, completion: @escaping (Result<String, Error>) -> Void) {
        NetworkManager.shared.loginUser(user: user, completion: completion)
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
