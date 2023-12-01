//
//  SessionWidgetLiveActivity.swift
//  SessionWidget
//
//  Created by Alex Šunjajev on 29.12.2023.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct SessionWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct SessionWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SessionWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension SessionWidgetAttributes {
    fileprivate static var preview: SessionWidgetAttributes {
        SessionWidgetAttributes(name: "World")
    }
}

extension SessionWidgetAttributes.ContentState {
    fileprivate static var smiley: SessionWidgetAttributes.ContentState {
        SessionWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: SessionWidgetAttributes.ContentState {
         SessionWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: SessionWidgetAttributes.preview) {
   SessionWidgetLiveActivity()
} contentStates: {
    SessionWidgetAttributes.ContentState.smiley
    SessionWidgetAttributes.ContentState.starEyes
}
