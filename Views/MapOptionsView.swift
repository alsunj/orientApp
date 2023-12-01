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
            .font(.system(size: 16))
            
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
            .font(.system(size: 16))
            
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
            .font(.system(size: 16))
            
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
            .font(.system(size: 16))
            
            Spacer()
        }
        .padding()
        .background(Color(red: 120/255.0, green: 220/255.0, blue: 120/255.0))

    }
            
}

#Preview {
    MapOptionsView()
}
