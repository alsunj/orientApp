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
                if context.state.isSessionActive {
                    SessionStatsWidget(context: context)
                    SessionControlsWidget()
                        .padding(.top, 10)
                } else {
                    Text("Well Done, you can view your sessions from the menu!")
                    // odav lahendus vana sessiooni kustutamisele, kahjuks mingit funktsiooni ei ole olemas et widgetit kustutada.
                }
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





