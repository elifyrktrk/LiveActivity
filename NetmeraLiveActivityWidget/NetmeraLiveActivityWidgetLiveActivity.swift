//
//  NetmeraLiveActivityWidgetLiveActivity.swift
//  NetmeraLiveActivityWidget
//
//  Created by Elif Yürektürk on 21.05.2025.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct NetmeraLiveActivityWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct NetmeraLiveActivityWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: NetmeraLiveActivityWidgetAttributes.self) { context in
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

extension NetmeraLiveActivityWidgetAttributes {
    fileprivate static var preview: NetmeraLiveActivityWidgetAttributes {
        NetmeraLiveActivityWidgetAttributes(name: "World")
    }
}

extension NetmeraLiveActivityWidgetAttributes.ContentState {
    fileprivate static var smiley: NetmeraLiveActivityWidgetAttributes.ContentState {
        NetmeraLiveActivityWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: NetmeraLiveActivityWidgetAttributes.ContentState {
         NetmeraLiveActivityWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: NetmeraLiveActivityWidgetAttributes.preview) {
   NetmeraLiveActivityWidgetLiveActivity()
} contentStates: {
    NetmeraLiveActivityWidgetAttributes.ContentState.smiley
    NetmeraLiveActivityWidgetAttributes.ContentState.starEyes
}
