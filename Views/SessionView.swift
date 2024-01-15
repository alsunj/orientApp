//
//  SessionView.swift
//  orientApp
//
//  Created by Alex Šunjajev on 10.01.2024.
//

import SwiftUI
import UIKit
import MessageUI
import SwiftSMTP
import CoreGPX

struct SessionView: View {
    private let mail = MailSender.shared
    @State var session: Session
    @State private var email = ""
    @State private var showMailAlert = false
    @State private var showRecreateAlert = false
    @State private var showSessionRecreationView = false
    
    @Binding var mailResult: Bool?
    @Binding var showMailResult: Bool
    
    var body: some View {
        Button {
            
            showRecreateAlert.toggle()
            
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(session.name)")
                        .font(.headline)
                        .foregroundColor(.blue)
                    Text("Created at: \(formatDateString(session.recordedAt))")
                        .foregroundColor(.white)
                    Text("Distance covered: \(formatDistance(session.distance)) meters")
                        .foregroundColor(.white)
                    Text("Time elapsed: \(session.duration)")
                        .foregroundColor(.white)
                    Text("Average speed: \(String(format: "%.2f", session.speed))")
                        .foregroundColor(.white)
                }
                .padding(.trailing, 20)
                
                Button {
                    showMailAlert.toggle()
                } label: {
                    Image(systemName: "arrow.down.circle")
                        .font(.title)
                }
            }
        }
        
        .padding(10)
        .background(.black)
        .listRowBackground(Color.black)
        .listRowSeparatorTint(.blue)
        .alert("Enter your email", isPresented: $showMailAlert) {
            TextField("your email here", text: $email)
            
            HStack {
                Button("Cancel") {
                    showMailAlert.toggle()
                }
                Button("OK") {
                    Task { @MainActor in
                        let gpxString = MailSender.shared.createGPXStringFromSession(session)
                        if let gpxData = gpxString.data(using: .utf8) {
                           let gpxAttachment = Attachment(
                               data: gpxData,
                               mime: "application/gpx+xml",
                               name: "session.gpx",
                               inline: false
                           )

                           MailSender.shared.sendMail(
                               toEmail: email,
                               subject: "Your session - \(session.name) gpx data",
                               attachment: gpxAttachment,
                               completion: { res in
                                   switch res {
                                   case .success:
                                       mailResult = true
                                   case .failure:
                                       mailResult = false
                                   }
                                   showMailResult = true
                               }
                           )
                        } else {
                           print("cant get gpx data")
                        }
                        
                    }
                }
                
            }
        } message: {
            Text("We will email you the GPX file of the track!")
        }
        .alert("Recreate Session", isPresented: $showRecreateAlert) {
            Button("No") {
                showRecreateAlert = false
            }
            Button("Yes") {
                showSessionRecreationView = true
            }
        } message: {
            Text("Are you sure you want to recreate this session?")
        }
        .navigationDestination(isPresented: $showSessionRecreationView) {
            SessionRecreationView(session: session)
            
        }
        
        
    }
    
    
    func formatDistance(_ distance: Double) -> String {
        let formattedDistance = String(format: "%.0f", distance)
        return "\(formattedDistance)"
    }
    
    func formatDateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss dd.MM.yyyy"
        return formatter.string(from: date)
    }
}
