//
//  orientAppApp.swift
//  orientApp
//
//  Created by Alex Šunjajev on 16.11.2023.
//

import SwiftUI
import SwiftData

@main
struct orientAppApp: App {
    @StateObject private var locationManager = LocationManager.shared
    @StateObject private var smanager = Manager.shared
   // @StateObject private var healthManager = HealthManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
 //               .environmentObject(healthManager)
                .environmentObject(smanager)
                .environmentObject(locationManager)
        }
    }
}
