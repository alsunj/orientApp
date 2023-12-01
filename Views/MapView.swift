//
//  TableView.swift
//  orientApp
//
//  Created by Alex Šunjajev on 23.11.2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    // TODO do this without shared?
    @ObservedObject var locationManager = LocationManager.shared
    @State private var userInitialLocation: MapCameraPosition = .userLocation(fallback: .automatic)
    var body: some View {
        
        
        
        VStack(spacing:0)  {
            MapOptionsView()
                .frame(height: 55)
                .padding(.bottom, 10)
            
            ZStack {
                if locationManager.userLocation == nil {
                    LocationRequestView()
                }
                else{
                    
                    Map(position: $userInitialLocation) {
                        UserAnnotation()
                        
                        MapPolyline(coordinates: locationManager.userLocations)
                            .stroke(Color.blue, lineWidth: 12)
                        
                        if let waypoint = locationManager.waypoint {
                            let waypointCoordinate = CLLocationCoordinate2D(latitude: waypoint.latitude, longitude: waypoint.longitude)
                            Annotation(
                                "Waypoint",
                                coordinate: waypointCoordinate,
                                anchor: .bottom) {
                                    Image(systemName: "pin")
                                        .padding(4)
                                        .foregroundStyle(.white)
                                        .background(.blue)
                                        .cornerRadius(4)
                                }
                        }
                        
                        ForEach(locationManager.checkpoints, id: \.checkPointId) { checkpoint in
                            let checkpointCoordinate = CLLocationCoordinate2D(latitude: checkpoint.latitude, longitude: checkpoint.longitude)
                            Annotation(
                                "Checkpoint \(checkpoint.checkPointId)",
                                coordinate: checkpointCoordinate,
                                anchor: .bottom) {
                                    Image(systemName: "mappin.and.ellipse")
                                        .padding(4)
                                        .foregroundStyle(.white)
                                        .background(.red)
                                        .cornerRadius(4)
                                }
                        }
                        
                        
                    }
                    
                    
                    
                    
                    .mapControls {
                        MapUserLocationButton()
                        MapScaleView()
                    }
                    
                    .navigationBarBackButtonHidden(true)
                    
                    .ignoresSafeArea()
                }
            }
        }
        
        ControlsView()
            .frame(width: UIScreen.main.bounds.size.width,
                   height:110, alignment: .top)
            .padding(.top, 10)
            .background(
                Color.init(
                    .sRGB,
                    red: 144/255.0,   // Red component
                    green: 238/255.0, // Green component
                    blue: 144/255.0,  // Blue component
                    opacity: 0.7      // Opacity
                ))
    }
}


#Preview{
    MapView()
}












