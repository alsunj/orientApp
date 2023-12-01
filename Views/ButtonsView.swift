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
        @State private var isSessionCreationSheetPresented = false
        
        @State private var isConfirmationAlertPresented = false
        var body: some View {
            
            
            HStack(spacing: 38) {
                Spacer()
                Button {
                    if Manager.shared.sessionStarted {
                        isConfirmationAlertPresented.toggle()
                    }
                    else{
                        isSessionCreationSheetPresented.toggle()
    //                    Manager.shared.sessionStarted.toggle()
                        
                        
                        
                    }
                }
            label: {
                Image(systemName: "arrowtriangle.right.circle.fill")
            }
                .padding()
                .cornerRadius(12.0)
                .background(smanager.sessionStarted ? .red : .green)
                .foregroundColor(.white)
                .clipShape(Circle())
                .font(.system(size: 9))
                .sheet(isPresented: $isSessionCreationSheetPresented) {
                    SessionCreationView(isPresented: $isSessionCreationSheetPresented, isSessionCreationSheetPresented: $isSessionCreationSheetPresented)
                        .environmentObject(smanager)  // Pass the smanager environment object

                  }

                
                
                Spacer()
                
                Button {
                    locationManager.addCheckpoint()


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
                    
                    if LocationManager.shared.waypoint != nil && Manager.shared.sessionStarted{
                        LocationManager.shared.waypoint = nil
                        LocationManager.shared.waypointPresented = false
                        
                    } else {
                                
                        locationManager.addWaypoint()
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
                        Task{ await
                            Manager.shared.stopSession()
                        }

                    },
                    secondaryButton: .cancel()
                )
            }
            
        }
    }


struct SessionCreationView: View {
    @Binding var isPresented: Bool
    @Binding var isSessionCreationSheetPresented: Bool
    @EnvironmentObject var smanager: Manager
    @State private var sessionName: String = ""
    @State private var description: String = ""
    @State private var isWalkingSelected: Bool = true
    
    var body: some View {
        VStack {
            Text("Session Details")
                .font(.headline)
                .padding()
            TextField("Session name",text: $sessionName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
            
            TextField("Description", text: $description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
            
            HStack {
                Image(systemName: isWalkingSelected ? "figure.run" : "figure.walk")
                Toggle(isOn: $isWalkingSelected) {
                    Text(isWalkingSelected ? "Running" : "Walking")
                }
                .labelsHidden()
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(8)
            Button(action: {
                Task {
                    await  Manager.shared.createSession(
                        name: sessionName,
                        description: description,
                        mode: isWalkingSelected ? .walking : .running
                    )
                    isSessionCreationSheetPresented = smanager.sessionStarted
                    print("session4 \( smanager.sessionStarted)")

                    
                    
                }
            }, label: {
                if smanager.sessionLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Create")
                }
            })
            .padding()
            
        }
        
    }
}


//    #Preview{
//        SessionCreationView()
//    }


