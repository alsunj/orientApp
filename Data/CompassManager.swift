//
//  CompassManager.swift
//  orientApp
//
//  Created by Alex Šunjajev on 16.11.2023.
//

import Combine
import SwiftUI
import CoreLocation


class CompassManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    static let shared = CompassManager()
    
    @Published var heading: Double = 0.0
    @Published var isCompassAvailable: Bool = false
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        isCompassAvailable = CLLocationManager.headingAvailable()
        
        if isCompassAvailable {
            locationManager.startUpdatingHeading()
        }
    }
    
    func checkCompassPermission() {
        func checkCompassPermission() {
            AuthorizationManager.requestAuthorization(for: locationManager)
            
        }
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
        // Handle authorization changes specific to CompassManager
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let magneticHeading = newHeading.magneticHeading
        let trueHeading = calculateTrueHeading(magneticHeading: magneticHeading)
        heading = trueHeading
    }
    
    private func calculateTrueHeading(magneticHeading: Double) -> Double {
        let magneticDeclination = locationManager.location?.horizontalAccuracy ?? 0.0
        let trueHeading = magneticHeading + magneticDeclination
        return trueHeading
    }
    func reset() {
        
    }
    func pause()
    {
        
    }
}
