//
//  ControlsView.swift
//  orientApp
//
//  Created by Alex Šunjajev on 25.11.2023.
//

import SwiftUI

struct ControlsView: View {
    @ObservedObject var locationManager = LocationManager.shared
    
    
    var body: some View {
        HStack{
            HStack{
                VStack() {
                    Table(variable: "Start  |",
                          value: $locationManager.distanceCovered)
                    HStack{
                        VStack {
                            Image(systemName: "clock")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                            
                        }
                        VStack{
                            Text(" | ")
                        }
                        VStack {
                            Text(locationManager.sessionDuration)
                        }
                    }
                    .padding(.bottom)
                    .font(.system(size: 9))
                    .cornerRadius(7)
                    .frame(maxWidth: UIScreen.main.bounds.size.width / 3.5)
                    PictureTableView(picture: "figure.walk",
                                     value: $locationManager.averageSpeed)
                }
                .padding(10)
                Rectangle()
                    .frame(width: 2, height: 90)
                    .foregroundColor(.black)
            }
            
            
            HStack{
                VStack() {
                    Table(variable: "CP | ",
                          value: $locationManager.distanceFromCp)
                    
                    
                    PictureTableView(picture: "swift",
                                     value: $locationManager.directLineFromCp)
                    PictureTableView(picture: "figure.walk",
                                     value: $locationManager.averageSpeedFromCp)
                }
                
                Rectangle()
                    .frame(width: 2)
                    .foregroundColor(.black)
                    .frame(width: 2, height: 90)
            }
            
            
            VStack() {
                Table(variable: "WP | ",
                      value: $locationManager.distanceFromWp)
                PictureTableView(picture: "swift",
                                 value: $locationManager.directLineFromWp)
                PictureTableView(picture: "figure.walk",
                                 value: $locationManager.averageSpeedFromWp)
            }
            
        }
        
        
    }
}

#Preview {
    ControlsView()
}
