//
//  UserLocation.swift
//  orientApp
//
//  Created by Alex Šunjajev on 28.11.2023.
//


import SwiftData
import Foundation
import CoreLocation

@Model
class UserLocation: Codable {
    var createdAt: Date
    var locationId: UUID
    var sessionId: UUID
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var accuracy: CLLocationAccuracy?
    var verticalAccuracy: CLLocationAccuracy?
    var altitude: Double?
    var locationType: LocationType?  // Match the key consistently
    var session: Session?

    enum CodingKeys: String, CodingKey {
        case createdAt
        case locationId
        case sessionId
        case latitude
        case longitude
        case accuracy
        case verticalAccuracy
        case altitude
        case locationType  // Match the key consistently
        case session
    }

    init(
        locationId: UUID,
        sessionId: UUID,
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees,
        accuracy: CLLocationAccuracy? = 0,
        verticalAccuracy: CLLocationAccuracy? = 0,
        altitude: Double? = 0,
        locationType: LocationType?,  // Adjust the parameter name
        session: Session?
    ) {
        self.createdAt = Date()
        self.locationId = locationId
        self.sessionId = sessionId
        self.latitude = latitude
        self.longitude = longitude
        if let accuracy = accuracy { self.accuracy = accuracy }
        if let verticalAccuracy = verticalAccuracy { self.verticalAccuracy = verticalAccuracy }
        if let altitude = altitude { self.altitude = altitude }
        self.locationType = locationType
        self.session = session
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        locationId = try container.decode(UUID.self, forKey: .locationId)
        sessionId = try container.decode(UUID.self, forKey: .sessionId)
        latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
        accuracy = try container.decode(CLLocationAccuracy.self, forKey: .accuracy)
        verticalAccuracy = try container.decode(CLLocationAccuracy.self, forKey: .verticalAccuracy)
        altitude = try container.decode(Double.self, forKey: .altitude)
        locationType = try container.decodeIfPresent(LocationType.self, forKey: .locationType)
        session = try container.decodeIfPresent(Session.self, forKey: .session)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(locationId, forKey: .locationId)
        try container.encode(sessionId, forKey: .sessionId)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(accuracy, forKey: .accuracy)
        try container.encode(verticalAccuracy, forKey: .verticalAccuracy)
        try container.encode(altitude, forKey: .altitude)
        try container.encode(locationType, forKey: .locationType)
        try container.encodeIfPresent(session, forKey: .session)
    }
}
