//
//  SessionStatsWidget.swift
//  orientApp
//
//  Created by Alex Šunjajev on 29.12.2023.
//

import SwiftUI
import ActivityKit
import WidgetKit

struct SessionStatsWidget: View {
    var context: ActivityViewContext<SessionAttributes>
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "map")
                .foregroundColor(Color(red: 70/255.0, green: 170/255.0, blue: 70/255.0))
            Text("\(String(format: "%.2f", context.state.sessionDistance)) m")
            Image(systemName: "clock")
                .foregroundColor(Color(red: 70/255.0, green: 170/255.0, blue: 70/255.0))
            Text("\(context.state.sessionDuration)")
            Image(systemName: "figure.walk")
                .foregroundColor(Color(red: 70/255.0, green: 170/255.0, blue: 70/255.0))
            Text("\(String(format: "%.2f", context.state.sessionSpeed)) km/h")
            
            
        }
        
        .font(.headline)
    }
}

