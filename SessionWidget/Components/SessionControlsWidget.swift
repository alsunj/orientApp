//
//  SessionControlsWidget.swift
//  orientApp
//
//  Created by Alex Šunjajev on 29.12.2023.
//
import SwiftUI
import ActivityKit

struct SessionControlsWidget: View {
    
    var body: some View {
        
        HStack {
            Spacer()
            
            Button(intent: StartOrStopIntent()) {
                Image(systemName: "play")
            }
            .buttonStyle(CustomButtonStyle())
            
            
            
            Spacer()
            
            Button(intent: AddCheckpointIntent()) {
                Image(systemName: "mappin.and.ellipse")
            }
            .buttonStyle(CustomButtonStyle())
            
            
            
            Spacer()
            
            Button(intent: AddWaypointIntent()) {
                Image(systemName: "pin")
            }
            .buttonStyle(CustomButtonStyle())
            
            
            Spacer()
            
        }
        
    }
    
}
struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.system(size: 20))
            .padding(10)
            .background(Color(red: 120/255.0, green: 220/255.0, blue: 120/255.0))
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 1.2 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

#Preview {    
    SessionControlsWidget()
        .environmentObject(LocationManager())
}
