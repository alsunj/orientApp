//
//  ButtonsView.swift
//  orientApp
//
//  Created by Alex Šunjajev on 01.12.2023.
//


import SwiftUI

struct ButtonsView: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var smanager: Manager
    @State private var isConfirmationAlertPresented = false
    var body: some View {
        
        
        HStack(spacing: 38) {
            Spacer()
            Button {
                if Manager.shared.sessionStarted {
                    isConfirmationAlertPresented.toggle()
                }
                else{
                    Manager.shared.sessionStarted.toggle()
                    
                }
            } label: {
                Image(systemName: "arrowtriangle.right.circle.fill")
            }
            .padding()
            .cornerRadius(12.0)
            .background(smanager.sessionStarted ? .red : .green)
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
                print("waypointPresented: \(LocationManager.shared.waypointPresented)")
                
                if LocationManager.shared.waypoint != nil {
                    LocationManager.shared.waypoint = nil
                    LocationManager.shared.waypointPresented = false
                    
                } else {
                    // Set waypointPresented to true if waypoint is set
                    LocationManager.shared.waypointPresented.toggle()
                }
            } label: {
                Image(systemName: "pin.circle.fill")
            }
            .padding()
            .cornerRadius(12.0)
            .background(locationManager.waypointPresented ? .red : .green)
            .foregroundColor(.white)
            .clipShape(Circle())
            .font(.system(size: 9))
            Spacer()
            
        }
        .padding()
        .frame(height: 50)
        .background(Color(red: 70/255.0, green: 170/255.0, blue: 70/255.0))
        .alert(isPresented: $isConfirmationAlertPresented) {
            Alert(
                title: Text("Confirmation"),
                message: Text("Are you sure you want to stop the session?"),
                primaryButton: .destructive(Text("Stop Session")) {
                    // Handle confirmation to stop the session
                    Manager.shared.sessionStarted.toggle()
                },
                secondaryButton: .cancel()
            )
        }
        
    }
}
#Preview {
    ButtonsView()
}
