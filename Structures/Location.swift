//
//  Location.swift
//  orientApp
//
//  Created by Alex Šunjajev on 16.11.2023.
//

import Foundation
import CoreLocation

struct Locations: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var description: String
    let latitude: Double
    let longitude: Double
        
    
}


