//
//  LocationRequestView.swift
//  orientApp
//
//  Created by Alex Šunjajev on 16.11.2023.
//

import SwiftUI
import MapKit

struct LocationRequestView: View {
    @State private var locationDeniedOnce = false

    var body: some View {
        ZStack {
            Map()
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Location required")
                    .font(.title)
                    .padding(30)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 45) {
                    Button {
                        if LocationManager.shared.requestLocation() {
                            // Location request succeeded
                        } else {
                            // Location request denied
                            if !locationDeniedOnce {
                                locationDeniedOnce = true
                                openAppSettings()
                            }
                        }
                    }label: {
                        Text("Allow location")
                            .padding()
                            .foregroundColor(.white.opacity(0.9))
                            .font(.headline)
                    }
                    .cornerRadius(12.0)
                    .frame(width: UIScreen.main.bounds.width / 2)
                    .padding(.horizontal, -32)
                    .background(.green)
                    .clipShape(Capsule())

                }
                .padding(32)
            }
        }
    }
    public func openAppSettings() {
            guard let appSettingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            
            if let bundleIdentifier = Bundle.main.bundleIdentifier,
               let appSettingsURL = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleIdentifier)") {
                UIApplication.shared.open(appSettingsURL)
            }
        }

}

#Preview {
    LocationRequestView()
}
