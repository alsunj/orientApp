//
//  UserLocation.swift
//  orientApp
//
//  Created by Alex Šunjajev on 28.11.2023.
//

import Foundation
import CoreLocation
import SwiftData

@Model
class UserLocation {
    @Attribute(.unique) var id: UUID
    var createdAt: Date
    var locationType: LocationType
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var accuracy: CLLocationAccuracy?
    var altitude: Double?
    @Relationship(deleteRule: .cascade) var session: Session?
    enum LocationType: String, Codable { case location, checkPoint, wayPoint }

    init(
        createdAt: Date,
        locationType: LocationType? = .location,
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees,
        accuracy: CLLocationAccuracy? = 0,
        altitude: Double? = 0,
        session: Session?
    ) {
        self.id = UUID()
        self.createdAt = Date()
        self.locationType = locationType ?? .location
        self.latitude = latitude
        self.longitude = longitude
        if let accuracy = accuracy { self.accuracy = accuracy }
        if let altitude = altitude { self.altitude = altitude }
        self.session = session
    }
}
