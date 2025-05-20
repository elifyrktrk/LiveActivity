import WidgetKit
import SwiftUI

struct MatchScoreWidget: Widget {
    let kind: String = "MatchScoreWidget"
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MatchScoreAttributes.self) { context in
            HStack(spacing: 20) {
                // Home Team
                VStack {
                    Text(context.state.homeTeamName.prefix(3))
                        .font(.headline)
                        .frame(width: 40, height: 40)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                    Text(context.state.homeTeamName)
                        .font(.caption)
                    Text("\(context.state.homeTeamScore)")
                        .font(.title)
                        .bold()
                }
                
                // Match Info
                VStack {
                    Text("\(context.state.minute)'")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("VS")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                
                // Away Team
                VStack {
                    Text(context.state.awayTeamName.prefix(3))
                        .font(.headline)
                        .frame(width: 40, height: 40)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Circle())
                    Text(context.state.awayTeamName)
                        .font(.caption)
                    Text("\(context.state.awayTeamScore)")
                        .font(.title)
                        .bold()
                }
            }
            .padding()
            .activityBackgroundTint(Color.black.opacity(0.1))
            .activitySystemActionForegroundColor(.black)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    HStack {
                        Text(context.state.homeTeamName.prefix(3))
                            .font(.headline)
                            .frame(width: 30, height: 30)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                        Text("\(context.state.homeTeamScore)")
                            .font(.title2)
                            .bold()
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    HStack {
                        Text("\(context.state.awayTeamScore)")
                            .font(.title2)
                            .bold()
                        Text(context.state.awayTeamName.prefix(3))
                            .font(.headline)
                            .frame(width: 30, height: 30)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
                
                DynamicIslandExpandedRegion(.center) {
                    Text("\(context.state.minute)'")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            } compactLeading: {
                Text("\(context.state.homeTeamScore)")
                    .font(.title3)
                    .bold()
            } compactTrailing: {
                Text("\(context.state.awayTeamScore)")
                    .font(.title3)
                    .bold()
            } minimal: {
                Text("\(context.state.homeTeamScore)-\(context.state.awayTeamScore)")
                    .font(.caption2)
            }
        }
    }
} 