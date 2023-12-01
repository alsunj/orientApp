//
//  Manager.swift
//  orientApp
//
//  Created by Alex Šunjajev on 29.11.2023.
//

import SwiftData
import Foundation
import MapKit
import SwiftUI
import WidgetKit
import ActivityKit

class Manager : NSObject, ObservableObject {
    

    static let shared = Manager()
    @Published var usertoken: String?
    @Published var sessionStarted: Bool = false
    @Published var sessionLoading = false
    @Published var loginLoading = false
    @Published var registerLoading = false
    @Published var currentUser: User?
    @Published var savedSession: Session? = nil
    @Published var sessionId: String?
    private var locationManager = LocationManager.shared
    var modelContext: ModelContext
    typealias GpsSessionType = NetworkManager.GpsSessionType
    typealias LocationType = NetworkManager.LocationType
    

   
    override init(){
        
        var modelContainer: ModelContainer = {
            do{
                let container = try! ModelContainer(
                    for: UserLocation.self,
                    UserModel.self,
                    Session.self,
                    configurations:ModelConfiguration()
                )
                return container
                
            }
            catch{
                print("failed to create a containter")
            }
        
        }()
        modelContext = ModelContext(modelContainer)

    }
    
   
        // Initialize the ModelContainer

        // Initialize the ModelContext from the ModelContainer
    func register(firstName: String, lastName: String, email: String, password: String) async {Task {
        registerLoading = true
        let user = await NetworkManager.shared.register(firstName: firstName, lastName: lastName, email: email, password: password)
        print("save to database started")
        if let user = user {
            print("Session started successfully")
            print("writing user to database", user)
            // Create a new User instance
            let userInstance = User(
                email: user.email,
                password: user.password,
                firstName: user.firstName!,
                lastName: user.lastName!,
                jwtToken: user.jwtToken!,
                sessionIds: []
            )
            print("saving user to database", userInstance)
            let userModel = UserModel(user: userInstance)
            modelContext.insert(userModel)
            try? modelContext.save()
            print("saved user to database", userModel)
        }
        else {
            print("Failed to register")
            
        }
        registerLoading = false
        
    }}
    
    func login(email: String, password: String) {
        loginLoading = true
        
        Task {
            let token = await NetworkManager.shared.login(email: email, password: password)
            
            if !token.isEmpty {
                // Fetch the user from the model context
                var fetchDescriptor = FetchDescriptor<UserModel>()
                fetchDescriptor.predicate = #Predicate<UserModel> { user in
                    user.email == email
                }
                let fetchedUserModels = try? modelContext.fetch(fetchDescriptor)
                
                if let fetchedUserModel = fetchedUserModels?.first {
                    // Set the current user to the fetched user
                    let fetchedUser = User(
                        email: fetchedUserModel.email,
                        password: fetchedUserModel.password,
                        firstName: fetchedUserModel.firstName,
                        lastName: fetchedUserModel.lastName,
                        jwtToken: fetchedUserModel.jwtToken,
                        sessionIds: fetchedUserModel.sessionIds
                    )
                    print(fetchedUser)
                    currentUser = fetchedUser
                    currentUser!.jwtToken = token
                    print("Token 14   ", token)
                    print("-----------", fetchedUserModel.sessionIds, "--------------")
                    // Insert the updated User instance into the model context
                    modelContext.insert(fetchedUserModel)
                    
                    // Save the model context
                    try? modelContext.save()
                } else {
                    // Handle the case where no user was found in the model context
                    print("No user found in the model context")
                }
            }
            
            loginLoading = false
        }
    }
    
    
    
    
    
    func createSession(name: String, description: String, mode: GpsSessionType) async {
        Task {
            sessionLoading = true
            
            let sessionStarted = await NetworkManager.shared.createSession(name: "SessionName", description: "SessionDescription", mode: mode)
            
            DispatchQueue.main.async {
                self.sessionStarted = sessionStarted // Update on the main thread
                if sessionStarted {
                    print("Session started successfully")
                    LocationManager.shared.trackingEnabled = true
                    SessionManager.shared.startActivity()
                    
                    if let currentUser = self.currentUser, let sessionId = self.sessionId {
                        self.savedSession = Session(
                            id: sessionId,
                            name: name,
                            description: description,
                            duration: "00:00:00",
                            speed: 0.0,
                            distance: 0.0
                        )
                        currentUser.sessionIds.append(sessionId)
                        let userModel = UserModel(user: currentUser)
                        self.modelContext.insert(userModel)
                        self.modelContext.insert(self.savedSession!)

                        try? self.modelContext.save()
                    } else {
                        print("Failed to start the session")
                    }
                }
                
            }
            sessionLoading = false
            
        }
    }
    func stopSession() async {
       Task {
           if let sessionId = sessionId {
               var fetchDescriptor = FetchDescriptor<Session>()
               fetchDescriptor.predicate = #Predicate<Session> { session in
                   session.id == sessionId
               }

               if let fetchedSession = try? modelContext.fetch(fetchDescriptor).first {
                   // Update the session
                   fetchedSession.duration = LocationManager.shared.sessionDuration
                   fetchedSession.speed = LocationManager.shared.averageSpeed
                   fetchedSession.distance = LocationManager.shared.distanceCovered

                   modelContext.insert(fetchedSession)
                   try? modelContext.save()
                   sessionStarted = false
               } else {
                   print("No session found with ID: \(sessionId)")
               }
              

           }
       }
    }


        
        func updateLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, locationType: LocationType) async {
            await NetworkManager.shared.updateLocation(latitude: latitude, longitude: longitude, locationType: locationType)
            let locationTypeIdString = locationTypeToId(locationType)
            guard let locationTypeEnum = UserLocation.LocationType(rawValue: locationTypeIdString)
            else {
                return
            }
            
            let locationUpdate = UserLocation(
                locationType: locationTypeEnum,
                latitude: latitude,
                longitude: longitude,
                session: savedSession
            )
            
            modelContext.insert(locationUpdate)
            try? modelContext.save()
        }
        
        func locationTypeToId(_ locationType: LocationType) -> String {
            switch locationType {
            case .location:
                return "00000000-0000-0000-0000-000000000001"
            case .checkPoint:
                return "00000000-0000-0000-0000-000000000002"
            case .wayPoint:
                return "00000000-0000-0000-0000-000000000003"
            }
        }
        
    func getSessions() async -> [Session] {
        guard let currentUser = currentUser, !currentUser.sessionIds.isEmpty else {
            return []
        }
        var sessions: [Session] = []
        print("sessions")
        
        for sessionId in currentUser.sessionIds {
            print("current user name: ", currentUser.firstName)
            print("current user session ID:", sessionId)
            
            var fetchDescriptor = FetchDescriptor<Session>()
            fetchDescriptor.predicate = #Predicate<Session> { session in
                session.id == sessionId
            }
            
            if let fetchedSession = try? modelContext.fetch(fetchDescriptor).first {
                sessions.append(fetchedSession)
            }
        }
        
        print("filtered", sessions)
        return sessions
    }
        func deleteSession(_ session: Session) async {
            modelContext.delete(session)
            try? modelContext.save()
        }
        
        func updateSession(_ session: Session) async {
            try? modelContext.save()
        }
        func saveUserToUserDefaults(user: User, forKey key: String) {
            currentUser = user
            if let encodedUser = try? JSONEncoder().encode(user) {
                UserDefaults.standard.set(encodedUser, forKey: key)
            }
        }
        
        
        func logout(){
            currentUser = nil
            
        }
        
        
        
        func reset() {
            LocationManager.shared.reset()
            CompassManager.shared.reset()
            // no point as it locationmanager and notificationmanager is reset individually    AuthorizationManager.shared.reset()
            NotificationManager.shared.resetNotifications()
        }
        
        
    }
    
    

