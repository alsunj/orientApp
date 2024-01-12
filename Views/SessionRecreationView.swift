//
//  SessionRecreationView.swift
//  orientApp
//
//  Created by Alex Šunjajev on 11.01.2024.
//

import SwiftUI
import MapKit

struct SessionRecreationView: View {
    @State private var speeds = [CLLocationSpeed]()
    var session: Session
    var body: some View {
        Map() {
            let coordinates = session.locations
                .filter { $0.locationType == .location }
                .sorted { $0.createdAt < $1.createdAt }
                .map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
            
            ForEach(0..<coordinates.count - 1, id: \.self) { i in
               if i < speeds.count {
                   let color = speedToColor(speeds[i])
                   MapPolyline(coordinates: [coordinates[i], coordinates[i + 1]])
                       .stroke(color, lineWidth: 5)
               }
            }

            if let waypoint = session.locations.last(where: { $0.locationType == .wayPoint }) {
                Annotation(
                    "Waypoint",
                    coordinate: CLLocationCoordinate2D(latitude: waypoint.latitude, longitude: waypoint.longitude),
                    anchor: .bottom) {
                        Image(systemName: "pin")
                            .padding(4)
                            .foregroundStyle(.white)
                            .background(.blue)
                            .cornerRadius(4)
                    }
            }
            
            let checkpoints = session.locations
                .filter { $0.locationType == .checkPoint }
                .sorted { $0.createdAt < $1.createdAt }

            ForEach(Array(zip(checkpoints.indices, checkpoints)), id: \.0) { i, cp in
                Annotation(
                    "Checkpoint \(i+1)",
                    coordinate: CLLocationCoordinate2D(latitude: cp.latitude, longitude: cp.longitude),
                    anchor: .bottom) {
                        Image(systemName: "mappin.and.ellipse")
                            .padding(4)
                            .foregroundStyle(.white)
                            .background(.red)
                            .cornerRadius(4)
                    }
            }

        }
        .mapControls {
            MapScaleView()
        }
        .onAppear {
                   let locations = session.locations
                       .filter { $0.locationType == .location }
                       .sorted { $0.createdAt < $1.createdAt }
            self.speeds = SpeedManager.shared.calculateSpeeds(locations: locations)
               }
        .mapStyle(.hybrid(elevation: .realistic))
    }
    func speedToColor(_ speed: CLLocationSpeed) -> Color {
       if speed <= 1 { // if speed is very slow, return red
           return Color.red
       } else if speed <= 2 { // if speed is moderate, return yellow
           return Color.orange
       } else if speed <= 3 {
           return Color.yellow
       }
        else {
            return Color.green
       }
    }
}


class SpeedManager {
    static let shared = SpeedManager()
    func calculateSpeeds(locations: [UserLocation]) -> [CLLocationSpeed] {
        var speeds = [CLLocationSpeed]()
        guard locations.count > 1 else { return speeds }
        
        for i in 0..<locations.count - 1 {
            let location1 = CLLocation(latitude: locations[i].latitude, longitude: locations[i].longitude)
            let location2 = CLLocation(latitude: locations[i + 1].latitude, longitude: locations[i + 1].longitude)
            let timeInterval = locations[i + 1].createdAt.timeIntervalSince(locations[i].createdAt)
            let speed = location1.distance(from: location2) / timeInterval
            speeds.append(speed)
        }
        
        return speeds
    }
}

