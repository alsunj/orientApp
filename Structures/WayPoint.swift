//
//  WayPoint.swift
//  orientApp
//
//  Created by Alex Šunjajev on 30.11.2023.
//

import Foundation
import CoreLocation


struct WayPoint {
    var wayPointId: UUID
    var sessionId: UUID
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
}
