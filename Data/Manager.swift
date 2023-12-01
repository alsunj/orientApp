//
//  Manager.swift
//  orientApp
//
//  Created by Alex Šunjajev on 29.11.2023.
//

import Foundation
import MapKit

class Manager : NSObject, ObservableObject {

    static let shared = Manager()
    @Published var usertoken: String?
    @Published var sessionStarted: Bool = false
    @Published var sessionLoading = false
    @Published var loginLoading = false
    @Published var registerLoading = false
    @Published var currentUser: User?
    typealias GpsSessionType = NetworkManager.GpsSessionType
    typealias LocationType = NetworkManager.LocationType


    

    
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
                    self.currentUser = user
                
            } catch {
                print("Login error: \(error)")

            }
            loginLoading = false
        }
    }


        
    func createSession(name: String, description: String, mode: GpsSessionType) async {
        Task {
            sessionLoading = true

            let sessionStarted = await NetworkManager.shared.createSession(name: "SessionName", description: "SessionDescription", mode: mode)

            DispatchQueue.main.async {
                self.sessionStarted = sessionStarted // Update on the main thread
                if sessionStarted {
                    print("Session started successfully")
                    LocationManager.shared.trackingEnabled = true
                } else {
                    print("Failed to start the session")
                }
            }
            sessionLoading = false

        }
    }
    
    
    func updateLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, locationType: LocationType) async {
           await NetworkManager.shared.updateLocation(latitude: latitude, longitude: longitude, locationType: locationType)
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

    func reset() {
        LocationManager.shared.reset()
        CompassManager.shared.reset()
    // no point as it locationmanager and notificationmanager is reset individually    AuthorizationManager.shared.reset()
        NotificationManager.shared.resetNotifications()
    }
    func pauseAllManagers(){
        LocationManager.shared.pause()
    }
}

