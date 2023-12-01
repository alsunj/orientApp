//
//  LocationManager.swift
//  orientApp
//
//  Created by Alex Šunjajev on 16.11.2023.
//
import CoreLocation
import ActivityKit



class LocationManager: NSObject, ObservableObject {
    
    
    @Published var userLocation: CLLocation?
    @Published var userLocations: [CLLocationCoordinate2D]?
    @Published var checkpoints: [String: CLLocationCoordinate2D] = [:]
    @Published var waypoint: CLLocationCoordinate2D?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var waypointPresented: Bool = false
    @Published var lastMoveTime: Date?
    
    
    enum GpsSessionType { case walking, running }
    enum LocationType { case location, checkPoint, wayPoint }
    
    
    private var timer: Timer?
    private var elapsedTime: TimeInterval = 0
    
    static let shared = LocationManager()
    static var idCounter = 0
    private let manager = CLLocationManager()
    
    @Published var distanceCovered: Double = 0.0
    @Published var distanceFromCp: Double = 0.0
    @Published var distanceFromWp: Double = 0.0
    @Published var directLineFromCp: Double = 0.0
    @Published var directLineFromWp: Double = 0.0
    @Published var sessionDurationSec: Double = 0.0
    @Published var sessionDuration: String = "00:00:00"
    @Published var averageSpeed: Double = 0.0
    @Published var averageSpeedFromCp: Double = 0.0
    @Published var averageSpeedFromWp: Double = 0.0
    @Published var sessionDurationBeforeCp = 0.0
    @Published var sessionDurationBeforeWp = 0.0
    private var lastPauseTime: Date?
    private var distanceSinceLastPause: Double = 0.0
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateElapsedTime()
            self?.calculateSpeeds()
            if(Manager.shared.trackingEnabled){
                SessionManager.shared.updateActivity(
                    distance: self?.distanceCovered ?? 0,
                    duration: self?.sessionDuration ?? "",
                    speed: self?.averageSpeed ?? 0
                )
            }
        }
    }
    
    
    override init() {
        super.init()
        print("init")
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        manager.startUpdatingLocation()
        
        self.setup()
    }
    
    
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
    }
    
    private func setup() {
        if CLLocationManager.headingAvailable() {
            manager.startUpdatingLocation()
            manager.startUpdatingHeading()
        }
    }
    func startSession(){
        Manager.shared.trackingEnabled = true
        startTimer()
    }
    func pauseSession() {
        timer?.invalidate()
        timer = nil
        elapsedTime += sessionDurationSec
    }
    func resumeSession() {
        startTimer()
        timer?.fireDate = Date().addingTimeInterval(-elapsedTime)
    }
    
    
}
extension LocationManager: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus = status
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        checkAndUpdateUserLocation(location: location)
    }
    func checkAndUpdateUserLocation(location: CLLocation) {
        if Manager.shared.trackingEnabled {
            if let previousLocation = userLocations?.last {
                let distance = location.distance(from: CLLocation(latitude: previousLocation.latitude, longitude: previousLocation.longitude))
                if distance > 1 && distance <= 5.0 {
                    Task {
                        await Manager.shared.updateLocation(
                            latitude: location.coordinate.latitude,
                            longitude: location.coordinate.longitude,
                            locationType: .location)
                    }
                    userLocations!.append(location.coordinate)
                    calculateDistances()
                    lastMoveTime = Date()
                    
                }
                
            } else {
                userLocations = [location.coordinate]
                lastMoveTime = Date()
            }
            
        }
        self.userLocation = location
        
        
    }
    func addCheckpoint() {
        if Manager.shared.trackingEnabled {
            print("addCheckpoint")
            
            let checkpointName = "Checkpoint \(checkpoints.count + 1)"
            checkpoints[checkpointName] = userLocation!.coordinate
            
            Task {
                await Manager.shared.updateLocation(
                    latitude: userLocation!.coordinate.latitude,
                    longitude: userLocation!.coordinate.longitude,
                    locationType: .checkPoint)
            }
            Task{ @MainActor in
                distanceFromCp = 0.0
                directLineFromCp = 0.0
            }
        }
    }
    
    func addWaypoint() {
        if Manager.shared.trackingEnabled {
            print("addWaypoint")
            Task { @MainActor in
                waypoint = userLocation!.coordinate
            }
            Task {
                await Manager.shared.updateLocation(
                    latitude: userLocation!.coordinate.latitude,
                    longitude: userLocation!.coordinate.longitude,
                    locationType: .checkPoint)
            }
            Task { @MainActor in
                distanceFromWp = 0.0
                directLineFromWp = 0.0
            }
        }
    }
    private func calculateDistances() {
        guard let locations = userLocations, locations.count >= 2 else { return }
        
        let lastLocation = CLLocation(latitude: locations.last!.latitude, longitude: locations.last!.longitude)
        let secondToLastLocation = CLLocation(latitude: userLocations![userLocations!.count - 2].latitude, longitude: userLocations![userLocations!.count - 2].longitude)
        
        
        if let lastMoveTime = lastMoveTime, abs(lastMoveTime.timeIntervalSinceNow) < elapsedTime {
            calculateDistanceCovered(secondToLastLocation: secondToLastLocation, lastLocation: lastLocation)
            calculateDistanceFromCp(secondToLastLocation: secondToLastLocation, lastLocation: lastLocation)
            calculateDistanceFromWp(secondToLastLocation: secondToLastLocation, lastLocation: lastLocation)
        }
    }
    
    private func calculateDistanceCovered(secondToLastLocation: CLLocation, lastLocation: CLLocation) {
        distanceCovered += lastLocation.distance(from: secondToLastLocation)
        
    }
    
    private func calculateDistanceFromCp(secondToLastLocation: CLLocation, lastLocation: CLLocation) {
        guard let lastCheckpointKey = checkpoints.keys.sorted().last, let lastCheckpoint = checkpoints[lastCheckpointKey] else { return }
        
        let lastCheckpointLocation = CLLocation(latitude: lastCheckpoint.latitude, longitude: lastCheckpoint.longitude)
        
        distanceFromCp += lastLocation.distance(from: secondToLastLocation)
        
        directLineFromCp = lastLocation.distance(from: lastCheckpointLocation)
    }
    
    private func calculateDistanceFromWp(secondToLastLocation: CLLocation, lastLocation: CLLocation) {
        guard waypoint != nil else { return }
        
        let waypointLocation = CLLocation(latitude: waypoint!.latitude, longitude: waypoint!.longitude)
        
        distanceFromWp += lastLocation.distance(from: secondToLastLocation)
        
        directLineFromWp = lastLocation.distance(from: waypointLocation)
    }
    
    private func calculateSpeeds() {
        
        
        if timer != nil {
            averageSpeed = (distanceCovered / sessionDurationSec) * 3.6
        }
        
        if checkpoints.count > 0 {
            averageSpeedFromCp = (distanceFromCp / sessionDurationSec) * 3.6
        }
        
        if waypoint != nil {
            averageSpeedFromWp = (distanceFromWp / sessionDurationSec) * 3.6
        }
    }
    
    private func updateElapsedTime() {
        sessionDurationSec += 1.0
        
        let hours = Int(sessionDurationSec) / 3600
        let minutes = (Int(sessionDurationSec) % 3600) / 60
        let seconds = Int(sessionDurationSec) % 60
        
        sessionDuration = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    var distanceFromWpString: String {
        return String(format: "%.2f", distanceFromWp)
    }
    func reset() {
        Manager.shared.trackingEnabled = false
        
        timer?.invalidate()
        timer = nil
        
        userLocations = nil
        checkpoints = [:]
        waypoint = nil
        
        distanceCovered = 0.0
        distanceFromCp = 0.0
        distanceFromWp = 0.0
        directLineFromCp = 0.0
        directLineFromWp = 0.0
        sessionDuration = "00:00:00"
        averageSpeed = 0.0
        averageSpeedFromCp = 0.0
        averageSpeedFromWp = 0.0
        sessionDurationSec = 0.0
        sessionDurationBeforeCp = 0.0
        sessionDurationBeforeWp = 0.0
    }
    
    
}


