//
//  LockScreenView.swift
//  orientApp
//
//  Created by Alex Šunjajev on 29.12.2023.
//

import SwiftUI
import HealthKit

//struct LockScreenView: View {
//    @EnvironmentObject var healthManager: HealthManager
//    @EnvironmentObject var locationManager: LocationManager
//    @EnvironmentObject var smanager: Manager
//    
//    var body: some View {
//            HStack{
//                Image(systemName: "shoeprints.fill")
//                Text("Step Count: \(healthManager.stepCount)")
//                    .padding()
//                Spacer()
//                Image(systemName: "mappin.and.ellipse")
//                Text("Distance from Checkpoint: \(locationManager.distanceFromCp)")
//                    .padding()
//           
//                Spacer()
//               
//            }
//         
//        
//        .onAppear(){
//            healthManager.fetchSessionSteps()
//        }
//
//    }
//}
//
//
////#Preview{
////    LockScreenView()
////        .environmentObject(HealthManager)
////}
//
