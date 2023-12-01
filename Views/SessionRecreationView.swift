//
//  SessionRecreationView.swift
//  orientApp
//
//  Created by Alex Šunjajev on 11.01.2024.
//

import SwiftUI
import MapKit
struct SessionRecreationView: View {
    var session: Session
    
    var body: some View {
        Map() {

        }
        .mapControls {
            MapScaleView()
        }
        .mapStyle(.hybrid(elevation: .realistic))
    }
}

