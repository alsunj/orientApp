//
//  Session.swift
//  orientApp
//
//  Created by Alex Šunjajev on 28.11.2023.
//

import Foundation
import SwiftData

@Model
class Session {
    @Attribute(.unique) var id: String
    var name: String
    var desc: String
    var recordedAt: Date
    var duration: String
    var speed: Double
    var distance: Double
    var locations = [UserLocation]()

    init(id: String, name: String, description: String, duration: String, speed: Double, distance: Double) {
        self.id = id
        self.name = name
        self.desc = description
        self.recordedAt = Date()
        self.duration = duration
        self.speed = speed
        self.distance = distance
    }
}


