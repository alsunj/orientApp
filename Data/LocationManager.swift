//
//  LocationManager.swift
//  orientApp
//
//  Created by Alex Šunjajev on 16.11.2023.
//
import CoreLocation

class LocationManager: NSObject, ObservableObject {
    

    @Published var userLocation: CLLocationCoordinate2D?
    @Published var userLocations: [CLLocationCoordinate2D] = []
    @Published var checkpoints: [CheckPoint] = []
    @Published var waypoint: WayPoint?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var waypointPresented: Bool = false

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
        manager.startUpdatingLocation()

        self.setup()
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
    }
    
    func requestLocation() {
            NotificationManager.shared.checkNotificationPermission()
            manager.delegate = self
            manager.requestWhenInUseAuthorization()
        }
    func checkAndUpdateUserLocation(_ newLocation: CLLocationCoordinate2D) {
        guard let lastLocation = userLocations.last else {
            // If there is no previous location, add the new location
            userLocations.append(newLocation)
            return
        }
        let newCLLocation = CLLocation(latitude: newLocation.latitude, longitude: newLocation.longitude)
        let lastCLLocation = CLLocation(latitude: lastLocation.latitude, longitude: lastLocation.longitude)

        let distance = newCLLocation.distance(from: lastCLLocation)

        if distance >= 10.0 {
            userLocations.append(newLocation)
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.first else { return }
            let newLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            checkAndUpdateUserLocation(newLocation)
            self.userLocation = newLocation
        }

    
    private func setup() {
        if CLLocationManager.headingAvailable() {
            manager.startUpdatingLocation()
            manager.startUpdatingHeading()
        }
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
}


