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
        let status = locationManager.authorizationStatus
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            break // Compass permission already granted
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Compass permission denied. Please enable it in Settings.")
        @unknown default:
            break
        }
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let magneticHeading = newHeading.magneticHeading
        let trueHeading = calculateTrueHeading(magneticHeading: magneticHeading)
        heading = trueHeading
    }

    private func calculateTrueHeading(magneticHeading: Double) -> Double {
        // Adjust the magnetic declination based on your location
        let magneticDeclination = locationManager.location?.horizontalAccuracy ?? 0.0
        let trueHeading = magneticHeading + magneticDeclination
        return trueHeading
    }
}
