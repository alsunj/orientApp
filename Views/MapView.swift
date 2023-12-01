//
//  TableView.swift
//  orientApp
//
//  Created by Alex Šunjajev on 23.11.2023.
//
import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var locationManager = LocationManager.shared
    @State private var userInitialLocation: MapCameraPosition = .userLocation(fallback: .automatic)

    var body: some View {
        VStack(spacing: 0) {
            MapOptionsView()
                .frame(height: 60)
            ZStack {
                if locationManager.userLocation == nil {
                    LocationRequestView()
                } else {
                    Map(position: $userInitialLocation) {
                        UserAnnotation()
                        
                        if let locations = locationManager.userLocations {
                            MapPolyline(coordinates: locations)
                                .stroke(Color.blue, lineWidth: 12)
                        }
                        
                        if let waypoint = locationManager.waypoint {
                            Annotation(
                                "Waypoint",
                                coordinate: waypoint,
                                anchor: .bottom) {
                                    Image(systemName: "pin")
                                        .padding(4)
                                        .foregroundStyle(.white)
                                        .background(.blue)
                                        .cornerRadius(4)
                                }
                        }
                        
                        ForEach(locationManager.checkpoints.keys.sorted(), id: \.self) { key in
                            if let checkpoint = locationManager.checkpoints[key] {
                                Annotation(
                                    key,
                                    coordinate: checkpoint,
                                    anchor: .bottom) {
                                        Image(systemName: "mappin.and.ellipse")
                                            .padding(4)
                                            .foregroundStyle(.white)
                                            .background(.red)
                                            .cornerRadius(4)
                                    }
                            }
                        }
                        
                    }
                    .mapControls {
                        MapUserLocationButton()
                        MapScaleView()
                    }
                    .mapStyle(.hybrid(elevation: .realistic))
                }
            }
            ButtonsView()
            ControlsView()
            .frame(maxHeight: .infinity, alignment: .top)
            .frame(width: UIScreen.main.bounds.size.width, height: 100, alignment: .top)
            .padding(.top, 10)
            .background(Color(red: 120/255.0, green: 220/255.0, blue: 120/255.0))

        }
        
    }
}



#Preview{
    MapView()
}












