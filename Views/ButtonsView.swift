//
//  ButtonsView.swift
//  orientApp
//
//  Created by Alex Šunjajev on 01.12.2023.
//


import SwiftUI

struct ButtonsView: View {
    var body: some View {
        HStack(spacing: 38) {
            Spacer()
            Button {
                print("Start")
            } label: {
                Image(systemName: "arrowtriangle.right.circle.fill")
            }
            .padding()
            .cornerRadius(12.0)
            .background(.green)
            .foregroundColor(.white)
            .clipShape(Circle())
            .font(.system(size: 9))
            
            Spacer()
            
            Button {
                print("Checkpoint")
            } label: {
                Image(systemName: "mappin.circle.fill")
            }
            .padding()
            .cornerRadius(12.0)
            .background(.green)
            .foregroundColor(.white)
            .clipShape(Circle())
            .font(.system(size: 9))
            
            Spacer()
            
            Button {
                print("Waypoint")
            } label: {
                Image(systemName: "pin.circle.fill")
            }
            .padding()
            .cornerRadius(12.0)
            .background(.green)
            .foregroundColor(.white)
            .clipShape(Circle())
            .font(.system(size: 9))
            Spacer()
        }
        
        .padding()
        .frame(height: 50)
        .background(Color(red: 70/255.0, green: 170/255.0, blue: 70/255.0)) // Slightly darker green

    }
}

#Preview {
    ButtonsView()
}
