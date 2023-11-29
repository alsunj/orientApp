//
//  Manager.swift
//  orientApp
//
//  Created by Alex Šunjajev on 29.11.2023.
//

import Foundation

class Manager {
    static let shared = Manager()

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
