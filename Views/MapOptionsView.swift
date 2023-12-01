//
//  MapOptionsView.swift
//  orientApp
//
//  Created by Alex Šunjajev on 16.11.2023.
//

import SwiftUI
struct MapOptionsView: View {
    @State private var isSettingsPresented = false

    var body: some View {
        HStack {
            CompassView()

            if CompassManager.shared.isCompassAvailable {
                CompassView()
                Spacer()
            }

            Button {
                CompassManager.shared.isCompassAvailable = true
                print("Compass")
            } label: {
                Image(systemName: "location.north.circle")
            }
            .padding()
            .cornerRadius(12.0)
            .background(.green)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .font(.system(size: 16))

            Spacer()

            NavigationLink(destination: SettingsView(), isActive: $isSettingsPresented) {
                EmptyView()
            }
            .hidden()

            Button {
                print("Options")
                isSettingsPresented.toggle() // Activate the navigation link
            } label: {
                Image(systemName: "gearshape")
            }
            .padding()
            .cornerRadius(12.0)
            .background(.green)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .font(.system(size: 16))
        }
        .padding()
        .background(Color(red: 120/255.0, green: 220/255.0, blue: 120/255.0))
    }
}


#Preview {
    MapOptionsView()
}
