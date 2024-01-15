//
//  SessionStatsWidget.swift
//  orientApp
//
//  Created by Alex Šunjajev on 29.12.2023.
//

import Foundation
import ActivityKit

class SessionManager: ObservableObject {
    static var shared = SessionManager()
    @Published var pauseSession: Bool = false
    
    @Published var activity: Activity<SessionAttributes>?
    
    func startActivity(state contentState: SessionAttributes.ContentState? = nil) {
        do {
            let initialState = SessionAttributes.ContentState(
                sessionDistance: contentState?.sessionDistance ?? 0.0,
                sessionDuration: contentState?.sessionDuration ?? "00:00:00",
                sessionSpeed: contentState?.sessionSpeed ?? 0.0
            )
            let session = SessionAttributes()
            
            let content = ActivityContent(state: initialState, staleDate: nil)
            
            self.activity = try Activity.request(
                attributes: session,
                content: content,
                pushType: nil
            )
        
        } catch (let e) {
            print("SessionManager startActivity() failed! Error:")
            print(e.localizedDescription)
        }
    }
    func updateActivity(
        distance: Double,
        duration: String,
        speed: Double
    ) {
        if let activity = activity {
            let contentState = SessionAttributes.ContentState(
                sessionDistance: distance,
                sessionDuration: duration,
                sessionSpeed: speed
            )
            
            Task {
                await activity.update(
                    ActivityContent<SessionAttributes.ContentState>(
                        state: contentState,
                        staleDate: nil
                    )
                )
                self.activity = activity
                
            }
        }
    }
    func stopActivity() {
           if let activity = activity {
               let contentState = SessionAttributes.ContentState(
                   sessionDistance: 0.0,
                   sessionDuration: "00:00:00",
                   sessionSpeed: 0.0,
                   isSessionActive: false
               )
               
               Task {
                   await activity.update(
                      ActivityContent<SessionAttributes.ContentState>(
                          state: contentState,
                          staleDate: nil
                      )
                   )
                   self.activity = activity
               }
           }
        
        
    }
    
    func addCheckpoint() {
        LocationManager.shared.addCheckpoint()
        print("Hello from addCheckpoint()")
    }
    
    func addWaypoint() {
        LocationManager.shared.addWaypoint()
        print("Hello from addWaypoint()")
    }
    func TogglePause(){
        if pauseSession{
            Manager.shared.resumeSession()
            
        }
        if !pauseSession{
            Manager.shared.pauseSession()
        }
    }
    
}
