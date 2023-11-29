//
//  AuthorizationManager.swift
//  orientApp
//
//  Created by Alex Šunjajev on 29.11.2023.
//

import Foundation
import CoreLocation


class AuthorizationManager {
    static let shared = AuthorizationManager()


    static func requestAuthorization(for manager: CLLocationManager) {
        manager.requestWhenInUseAuthorization()
    }
    static func requestNotificationAuthorization() {
           // Implement notification authorization logic
       }
    func reset() {
            
        }
    func pause()
    {
        
    }
}
