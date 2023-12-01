//
//  pauseIntent.swift
//  orientApp
//
//  Created by Alex Šunjajev on 29.12.2023.
//

import Foundation
import ActivityKit
import AppIntents

@available(iOS 17.0, *)
struct StartOrStopIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "Live Activity"
    
    func perform() async throws -> some IntentResult {
        
        //SessionManager().pauseAllManagers()
        
        return .result()
    }
}
