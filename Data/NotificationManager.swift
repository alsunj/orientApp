//
//  NotificationManager.swift
//  orientApp
//
//  Created by Alex Šunjajev on 29.11.2023.
//

import Foundation


class NotificationManager {
    static let shared = NotificationManager()

    static func requestLocationAuthorization() {
            LocationManager.shared.requestLocation()
        }
    func checkNotificationPermission() {
        AuthorizationManager.requestNotificationAuthorization()
    }

    func reset() {
            
        }
    func pause()
    {
        
    }
}
