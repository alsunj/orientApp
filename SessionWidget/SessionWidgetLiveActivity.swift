//
//  SessionWidgetLiveActivity.swift
//  SessionWidget
//
//  Created by Alex Šunjajev on 29.12.2023.
//

import ActivityKit
import WidgetKit
import SwiftUI

@main
struct SessionWidgetLiveActivity: Widget {
    static let shared = SessionWidgetLiveActivity()
    @ObservedObject var sessionManager = SessionManager.shared
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SessionAttributes.self) { context in
            VStack {
                SessionStatsWidget(context: context)
                SessionControlsWidget()
                    .padding(.top, 10)
            }
            .padding(.top, 10)
            .padding(.bottom, 10)
            .activityBackgroundTint(.clear)
            .activitySystemActionForegroundColor(.black)
            
        }dynamicIsland: { _ in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) { EmptyView() }
                DynamicIslandExpandedRegion(.trailing) { EmptyView() }
                DynamicIslandExpandedRegion(.bottom) { EmptyView() }
            } compactLeading: { EmptyView() }
        compactTrailing: { EmptyView() }
        minimal: { EmptyView() }
        }
    }
}





