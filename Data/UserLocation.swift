//
//  UserLocation.swift
//  orientApp
//
//  Created by Alex Šunjajev on 28.11.2023.
//

import Foundation
import CoreLocation

struct UserLocation {
    var locationId: UUID
    var sessionId: UUID
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
}
