//
//  MapOptionsView.swift
//  orientApp
//
//  Created by Alex Šunjajev on 16.11.2023.
//

import SwiftUI

struct MapOptionsView: View {
    var body: some View {
        HStack {
            CompassView()
                .tint(.black)
                .controlSize(.large)
            Spacer()
            
            Button {
                print("North-up")
            } label: {
                Image(systemName: "arrowshape.up")
            }
            .padding()
            .cornerRadius(12.0)
            .background(.green)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .font(.system(size: 24))
            
            Spacer()
            
            Button {
                print("Reset")
            } label: {
                Image(systemName: "gobackward")
            }
            .padding()
            .cornerRadius(12.0)
            .background(.green)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .font(.system(size: 24))
            
            Spacer()
            
            Button {
                print("Compass")
            } label: {
                Image(systemName: "location.north.circle")
            }
            .padding()
            .cornerRadius(12.0)
            .background(.green)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .font(.system(size: 24))
            
            Spacer()
            
            Button {
                print("Options")
            } label: {
                Image(systemName: "gearshape")
            }
            .padding()
            .cornerRadius(12.0)
            .background(.green)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .font(.system(size: 24))
            
            Spacer()
        }
        .padding()
        .background(
            Color.init(
                .sRGB,
                red: 144/255.0,   // Red component
                green: 238/255.0, // Green component
                blue: 144/255.0,  // Blue component
                opacity: 0.8      // Opacity
            ))
    }
            
}

#Preview {
    MapOptionsView()
}
