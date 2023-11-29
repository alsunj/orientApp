//
//  LocationManager.swift
//  orientApp
//
//  Created by Alex Šunjajev on 16.11.2023.
//
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    

    @Published var userLocation: CLLocation?
    @Published var userLocations: [CLLocationCoordinate2D]?
    @Published var checkpoints: [String: CLLocationCoordinate2D] = [:]
    @Published var waypoint: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

    static let shared = LocationManager()
    static var idCounter = 0
    private let manager = CLLocationManager()
    
    @Published var distanceCovered: Double = 0.0
    @Published var distanceFromCp: Double = 0.0
    @Published var distanceFromWp: Double = 0.0
    @Published var directLineFromCp: Double = 0.0
    @Published var directLineFromWp: Double = 0.0
    @Published var sessionDuration: String = "00:00:00"
    @Published var averageSpeed: Double = 0.0
    @Published var averageSpeedFromCp: Double = 0.0
    @Published var averageSpeedFromWp: Double = 0.0
    


    
    override init() {
        super.init()
        print("init")
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        self.setup()
    }
    
    func requestLocation() -> Bool {
        AuthorizationManager.requestAuthorization(for: manager)
        return authorizationStatus == .authorizedWhenInUse


        }

    
    private func setup() {
        if CLLocationManager.headingAvailable() {
            manager.startUpdatingLocation()
            manager.startUpdatingHeading()
        }
    }
   

    func addCheckpoint(coordinate: CLLocationCoordinate2D) {
            let checkpointName = "Checkpoint \(checkpoints.count + 1)"
            checkpoints[checkpointName] = coordinate
            print(checkpoints)
        
    }
 
    func addWaypoint(coordinate: CLLocationCoordinate2D) {
            waypoint = coordinate
    }
    
    var distanceFromWpString: String {
            return String(format: "%.2f", distanceFromWp)
        }
 
    func reset() {
            
        }
    func pause()
    {
        
    }


 }





extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status

       }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        if let previousLocation = userLocations?.last {
            let distance = location.distance(from: CLLocation(latitude: previousLocation.latitude, longitude: previousLocation.longitude))
            print(distance)
            
            if distance > 0 && distance <= 10.0 { userLocations!.append(location.coordinate) } // I know that the array exists otherwise I would not make it here
        } else {
            userLocations = [location.coordinate]
        }
        
        self.userLocation = location
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
        print(newHeading.magneticHeading)
    }
}

