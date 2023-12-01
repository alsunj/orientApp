//
//  LocationType.swift
//  orientApp
//
//  Created by Alex Šunjajev   on 24.12.2023.
//
import Foundation

struct LocationType: Codable {
    var name: String
    var description: String
    var id: UUID
    var type: LocationTypeType // Enum to differentiate between LOC, WP, CP

    enum CodingKeys: String, CodingKey {
        case name
        case description
        case id
        case type
    }
}

enum LocationTypeType: String, Codable {
    case LOC
    case WP
    case CP
}
