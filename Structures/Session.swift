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
struct LocationType: Decodable {
    let name: String
    let description: String
    let id: String
}

struct Location: Codable {
    let recordedAt: String
    let latitude: Double
    let longitude: Double
    let accuracy: Double
    let altitude: Double
    let verticalAccuracy: Double
    let gpsSessionId: String
    let gpsLocationTypeId: String
}
