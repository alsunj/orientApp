//
//  sessionData.swift
//  orientApp
//
//  Created by Alex Šunjajev on 09.01.2024.
//

import Foundation
import SwiftSMTP
import CoreGPX

struct MailSender {
    static let shared = MailSender()
    private let config = Config.shared
    private let smtp: SMTP
    private let fromEmail: Mail.User
    
    init() {
        self.smtp = SMTP(
            hostname: config.smtpHostname,
            email: config.smtpEmail,
            password: config.smtpPassword
        )
        
        fromEmail = Mail.User(email: config.smtpEmail)
    }
    
    
    func sendMail(
        toEmail to: String,
        subject: String,
        body: String,
        completion: @escaping (Result<Void, Error>) -> Void) {
            let toEmail = Mail.User(email: to)
            
            let mail = Mail(
                from: fromEmail,
                to: [toEmail],
                subject: subject,
                text: body
            )
            
            Task { @MainActor in
                smtp.send(mail) { error in
                    if let error = error {
                        completion(.failure(error))
                    }
                }
                completion(.success(()))
            }
        }
    func createGPXStringFromSession(_ session: Session) -> String {
        let gpx = GPXRoot(creator: "orientApp")
        
        // Create a track segment for the session
        let trackSegment = GPXTrackSegment()
        
        // Add track points for each location in the session
        for location in session.locations {
            let trackPoint = GPXTrackPoint(latitude: location.latitude, longitude: location.longitude)
            trackPoint.elevation = location.altitude
            trackPoint.time = location.createdAt
            trackSegment.add(trackpoint: trackPoint)
        }
        
        // Create a track and add the track segment to it
        let track = GPXTrack()
        track.add(trackSegment: trackSegment)
        
        // Add the track to the GPX object
        gpx.add(track: track)
        print (gpx.gpx())
        
        return gpx.gpx()
    }
    
}
