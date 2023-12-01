//
//  orientAppApp.swift
//  orientApp
//
//  Created by Alex Šunjajev on 16.11.2023.
//

import SwiftUI

@main
struct orientAppApp: App {
    @StateObject private var locationManager = LocationManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager)

        }
    }
}
