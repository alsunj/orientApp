//
//  MapOptionsView.swift
//  orientApp
//
//  Created by Alex Šunjajev on 16.11.2023.
//

import SwiftUI
struct MapOptionsView: View {
    @State private var isSettingsPresented = false
    @State private var isCompassViewPresented = false
    
    var body: some View {
        HStack {
            Button {
                isCompassViewPresented.toggle()
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
            
            if isCompassViewPresented {
                CompassView()
                Spacer()
            }
            
            Button {
                print("Options")
                isSettingsPresented.toggle()
            } label: {
                Image(systemName: "gearshape")
            }
            .padding()
            .cornerRadius(12.0)
            .background(.green)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .font(.system(size: 16))
            .navigationDestination(isPresented: $isSettingsPresented) {
                SettingsView()
            }
        }
        .padding()
        .background(Color(red: 120/255.0, green: 220/255.0, blue: 120/255.0))
    }
}


#Preview {
    MapOptionsView()
}
