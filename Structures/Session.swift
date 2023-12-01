//
//  Session.swift
//  orientApp
//
//  Created by Alex Šunjajev on 28.11.2023.
//

import Foundation

struct Session: Decodable {
    var sessionId: UUID?
    var name: String
    var description: String
    var recordedAt: Date
    var minSpeed: Double
    var maxSpeed: Double

    enum CodingKeys: String, CodingKey {
        case sessionId
        case name
        case description
        case recordedAt
        case minSpeed
        case maxSpeed
    }
}
struct LocationType {
    var id: UUID
    var name: String
    var description: String
}

struct LocationUpdate {
    var recordedAt: Date
    var latitude: Double
    var longitude: Double
    var accuracy: Double
    var altitude: Double
    var verticalAccuracy: Double
    var gpsSessionId: UUID
    var gpsLocationTypeId: UUID
}
