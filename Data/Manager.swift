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
    @Published var registerSuccessful = false
    @Published var loginSuccessful = false
    @Published var currentUser: User?
    @Published var savedSession: Session? = nil
    @Published var sessionId: String?
    @Published var trackingEnabled: Bool = false
    
    private var locationManager = LocationManager.shared
    var modelContext: ModelContext
    typealias GpsSessionType = NetworkManager.GpsSessionType
    typealias LocationType = NetworkManager.LocationType
    
    
    
    override init(){
        
        let modelContainer: ModelContainer = {
            let container = try! ModelContainer(
                for: UserLocation.self,
                UserModel.self,
                Session.self,
                configurations:ModelConfiguration()
            )
            return container
        }()
        modelContext = ModelContext(modelContainer)
        
    }
    @MainActor
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
    @MainActor
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
                    print("-----------", currentUser?.email, "--------------")
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
    
    
    
    
    @MainActor
    func createSession(name: String, description: String, mode: GpsSessionType) async {
        Task {
            sessionLoading = true
            
            let sessionStarted = await NetworkManager.shared.createSession(name: "SessionName", description: "SessionDescription", mode: mode)
            
            DispatchQueue.main.async {
                self.sessionStarted = sessionStarted // Update on the main thread
                if sessionStarted {
                    print("Session started successfully")
                    
                    LocationManager.shared.startSession()
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
                        self.modelContext.insert(self.savedSession!)
                        
                        
                        var fetchDescriptor = FetchDescriptor<UserModel>()
                        fetchDescriptor.predicate = #Predicate<UserModel> { user in
                            user.email == currentUser.email
                        }
                        
                        do {
                            let users = try self.modelContext.fetch(fetchDescriptor)
                            
                            if let user = users.first {
                                // Append the sessionId to the user's sessionIds array
                                user.sessionIds.append(sessionId)
                                
                                // Insert the updated user object back into the context
                                self.modelContext.insert(user)
                                
                                // Save the changes
                                try self.modelContext.save()
                            } else {
                                print("User not found with the specified email")
                            }
                        } catch {
                            print("Error fetching user: \(error)")
                        }
                    } else {
                        print("Failed to start the session")
                    }
                }
                
                self.sessionLoading = false
            }
        }
    }
    @MainActor
    func stopSession() async {
        Task {
            if let sessionId = sessionId {
                var fetchDescriptor = FetchDescriptor<Session>()
                fetchDescriptor.predicate = #Predicate<Session> { session in
                    session.id == sessionId
                }
                //               if let fetchedSession = try? modelContext.fetch(fetchDescriptor).first {
                //                  print("Locations fetched from database: \(fetchedSession.locations)")
                //               }
                
                if let fetchedSession = try? modelContext.fetch(fetchDescriptor).first {
                    fetchedSession.duration = LocationManager.shared.sessionDuration
                    fetchedSession.speed = LocationManager.shared.averageSpeed
                    fetchedSession.distance = LocationManager.shared.distanceCovered
                    
                    //                   var fetchDescriptor = FetchDescriptor<UserLocation>()
                    //                   fetchDescriptor.predicate = #Predicate<UserLocation> { userLocation in
                    //                                   userLocation.session?.id == sessionId
                    //                                 }
                    //                   if let locations = try? modelContext.fetch(fetchDescriptor) {
                    //                       print("-------------\(locations)---------------------")
                    //                       let sessionLocations = locations.filter { $0.session?.id == sessionId }
                    //                       print("Locations added to session: \(sessionLocations)")
                    //                       fetchedSession.locations = sessionLocations
                    //                   }
                    modelContext.insert(fetchedSession)
                    try? modelContext.save()
                    sessionStarted = false
                    
                } else {
                    print("No session found with ID: \(sessionId)")
                }
                
                
            }
        }
    }
    
    
    @MainActor
    func updateLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, locationType: LocationType) async {
        await NetworkManager.shared.updateLocation(latitude: latitude, longitude: longitude, locationType: locationType)

        guard let sessionId = sessionId else {
                    print("sessionId is nil")
                    return
                }
        let mappedLocationType = locationTypeToUserLocationType(locationType)
        print("-------,\(mappedLocationType)")
        let locationUpdate = UserLocation(
            createdAt: Date(),
            locationType: mappedLocationType,
            latitude: latitude,
            longitude: longitude,
            session: savedSession
        )
        print("4")
        let updatedSession = savedSession
                    var fetchDescriptor = FetchDescriptor<Session>()
                    fetchDescriptor.predicate = #Predicate<Session> { session in
                        session.id == sessionId
                    }
                    if let fetchedSession = try? modelContext.fetch(fetchDescriptor).first {
                           fetchedSession.locations.append(locationUpdate)
                        print("----------",fetchedSession.locations,"-----------")

                           try? modelContext.save()
                       }
        
        modelContext.insert(locationUpdate)
        try? modelContext.save()
    }
    
    func locationTypeToUserLocationType(_ networkManagerLocationType: NetworkManager.LocationType) -> UserLocation.LocationType {
       switch networkManagerLocationType {
       case .location:
           return .location
       case .checkPoint:
           return .checkPoint
       case .wayPoint:
           return .wayPoint
       }
    }
    
    
    //    func fetchSession(sessionId: String) -> Session? {
    //       var fetchDescriptor = FetchDescriptor<Session>()
    //       fetchDescriptor.predicate = #Predicate<Session> { session in
    //           session.id == sessionId
    //       }
    //
    //       if let fetchedSession = try? modelContext.fetch(fetchDescriptor).first {
    //           return fetchedSession
    //       } else {
    //           print("Failed to fetch session with ID: \(sessionId)")
    //           return nil
    //       }
    //    }
    // textfield views mis otsib kindla session.namei-ga sessiooni
    @MainActor
    func fetchSession(sessionId: String) -> Session? {
        var fetchDescriptor = FetchDescriptor<Session>()
        fetchDescriptor.predicate = #Predicate<Session> { session in
            session.id == sessionId
        }
        
        return try? modelContext.fetch(fetchDescriptor).first
    }
    @MainActor
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
    
    
    func logout(){
        currentUser = nil
        //reset()
        
    }
    func pauseSession()
    {
        trackingEnabled = false
        LocationManager.shared.pauseSession()
    }
    
    func resumeSession(){
        trackingEnabled = true
        LocationManager.shared.resumeSession()
        
    }
    func reset() {
        LocationManager.shared.reset()
        CompassManager.shared.reset()
        // no point as it locationmanager and notificationmanager is reset individually    AuthorizationManager.shared.reset()
        //   NotificationManager.shared.resetNotifications()
    }
    //        func saveUserToUserDefaults(user: User, forKey key: String) {
    //            currentUser = user
    //            if let encodedUser = try? JSONEncoder().encode(user) {
    //                UserDefaults.standard.set(encodedUser, forKey: key)
    //            }
    //        }
    //
    
    
    
}



