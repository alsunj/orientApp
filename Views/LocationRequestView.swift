//
//  LocationRequestView.swift
//  orientApp
//
//  Created by Alex Šunjajev on 16.11.2023.
//

import SwiftUI
import MapKit

struct LocationRequestView: View {
    @EnvironmentObject var locationManager: LocationManager

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
                        if locationManager.authorizationStatus == .denied || locationManager.authorizationStatus == .restricted {
                                                    openAppSettings()
                                                } else {
                                                    AuthorizationManager.requestLocationAuthorization()
                                                }                    }label: {
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
        
        if UIApplication.shared.canOpenURL(appSettingsURL) {
            UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
        } else {
            // Handle error or provide alternative action
        }
    }

}

#Preview {
    LocationRequestView()
}
