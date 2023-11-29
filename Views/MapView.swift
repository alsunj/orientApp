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
<<<<<<< HEAD
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













=======
    @State private var tapCount = 0
    @ObservedObject var locationManager = LocationManager.shared
    @State private var formattedDistanceFromWp: String = ""
    @State private var userInitialLocation: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var FormattedDistanceFromWp: String = "104.52"
    private let mapView = MKMapView()
    
    var body: some View {
  
        
          
        VStack(spacing:-4)  {
                MapOptionsView()
                    .frame(height: 55)
                    .padding(.bottom, 10)
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
                                            
                                                .foregroundStyle(.white)
                                                .background(.red)
                                                .cornerRadius(4)
                                        }
                                }
                            }
                        }
                        .onAppear {
                            print(locationManager.userLocation?.coordinate as Any)
                            let region = MKCoordinateRegion(center: locationManager.userLocation!.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                            print(region)
                            mapView.setRegion(region, animated: false)
                        }
                        .onTapGesture {
                            tapCount += 1
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6
                            ) {
                                if tapCount == 1 {
                                    // Single tap action
                                    let location = mapView.centerCoordinate
                                    print("Single tap at \(location)")
                                    // Perform single tap action here if needed
                                } else if tapCount == 2 {
                                    // Double tap action
                                    let location = mapView.centerCoordinate
                                    print("Double tap at \(location)")
                                    locationManager.addWaypoint(coordinate: location)
                                    locationManager.addCheckpoint(coordinate: location)
                                }
                                tapCount = 0
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
                
                
               Spacer()
                HStack{
                    HStack{
                        VStack(spacing: 15) {
                            Table(variable: "Start  |",
                                  value: $locationManager.distanceCovered)
                            PictureTableView(picture: "clock",
                                  value: $locationManager.sessionDuration)
                            PictureTableView(picture: "figure.walk",
                                  value: $locationManager.averageSpeed)
                        }
                        .padding(10)
                        Rectangle()
                            .frame(width: 2)
                            .foregroundColor(.black)
                    }
                    
                    
                    HStack{
                        VStack(spacing: 15) {
                            Table(variable: "Range  | ",
                                  value: $locationManager.distanceFromCp)
                           
                            
                            PictureTableView(picture: "swift",
                                  value: $locationManager.directLineFromCp)
                            PictureTableView(picture: "figure.walk",
                                  value: $locationManager.averageSpeedFromCp)
                        }
                        
                        Rectangle()
                            .frame(width: 2)
                            .foregroundColor(.black)
                    }
                    
                    
                    VStack(spacing: 15) {
                        Table(variable: "Range | ",
                              value: $locationManager.distanceFromWp)
                        PictureTableView(picture: "swift",
                              value: $locationManager.directLineFromWp)
                        PictureTableView(picture: "figure.walk",
                              value: $locationManager.averageSpeedFromWp)
                    }
                    
                }
                
                
                
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
            
            
        }
    
        
        
        
        
    



#Preview {
    MapView()
}
>>>>>>> main


