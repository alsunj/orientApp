//
//  Session.swift
//  orientApp
//
//  Created by Alex Šunjajev on 28.11.2023.
//

import Foundation
import SwiftData

@Model
class Session: Codable {
    var sessionId : UUID
    var sessionName: String
    var sessionDescription: String
    var createdAt: Date
    var minSpeed: Double
    var maxSpeed: Double
    var distanceCovered: Double
    var timeElapsed: Double
    var averageSpeed: Double
    @Relationship(deleteRule: .cascade, inverse: \UserLocation.session)
    var checkPoints = [UserLocation]()
    @Relationship(deleteRule: .cascade, inverse: \UserLocation.session)
    var wayPoints = [UserLocation]()
    @Relationship(deleteRule: .cascade, inverse: \UserLocation.session)
    var locations = [UserLocation]()
    var user: User?
    
    
    enum CodingKeys: String, CodingKey {
        case sessionId
        case sessionName
        case sessionDescription
        case createdAt
        case minSpeed
        case maxSpeed
        case distanceCovered
        case timeElapsed
        case averageSpeed
        case checkPoints
        case wayPoints
        case locations
        case user
    }
    
    init(
        sessionId: UUID = UUID(),
        sessionName: String,
        sessionDescription: String,
        createdAt: Date = Date(),
        minSpeed: Double = 60,
        maxSpeed: Double = 600,
        distanceCovered: Double = 0,
        timeElapsed: Double = 0,
        averageSpeed: Double = 0,
        checkPoints: [UserLocation] = [],
        wayPoints: [UserLocation] = [],
        locations: [UserLocation] = []
    ) {
        self.sessionId = sessionId
        self.sessionName = sessionName
        self.sessionDescription = sessionDescription
        self.createdAt = createdAt
        self.minSpeed = minSpeed
        self.maxSpeed = maxSpeed
        self.distanceCovered = distanceCovered
        self.timeElapsed = timeElapsed
        self.averageSpeed = averageSpeed
        self.checkPoints = checkPoints
        self.wayPoints = wayPoints
        self.locations = locations
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sessionId = try container.decode(UUID.self, forKey: .sessionId)
        sessionName = try container.decode(String.self, forKey: .sessionName)
        sessionDescription = try container.decode(String.self, forKey: .sessionDescription)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        minSpeed = try container.decode(Double.self, forKey: .minSpeed)
        maxSpeed = try container.decode(Double.self, forKey: .maxSpeed)
        distanceCovered = try container.decode(Double.self, forKey: .distanceCovered)
        timeElapsed = try container.decode(Double.self, forKey: .timeElapsed)
        averageSpeed = try container.decode(Double.self, forKey: .averageSpeed)
        checkPoints = try container.decode([UserLocation].self, forKey: .checkPoints)
        wayPoints = try container.decode([UserLocation].self, forKey: .wayPoints)
        locations = try container.decode([UserLocation].self, forKey: .locations)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sessionId, forKey: .sessionId)
        try container.encode(sessionName, forKey: .sessionName)
        try container.encode(sessionDescription, forKey: .sessionDescription)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(minSpeed, forKey: .minSpeed)
        try container.encode(maxSpeed, forKey: .maxSpeed)
        try container.encode(distanceCovered, forKey: .distanceCovered)
        try container.encode(averageSpeed, forKey: .averageSpeed)
        try container.encode(checkPoints, forKey: .checkPoints)
        try container.encode(wayPoints, forKey: .wayPoints)
        try container.encode(locations, forKey: .locations)
    }
}
