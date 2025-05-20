import WidgetKit
import SwiftUI

struct PomodoroWidget: Widget {
    let kind: String = "PomodoroWidget"
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PomodoroAttributes.self) { context in
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: context.state.isBreak ? "cup.and.saucer.fill" : "timer")
                        .foregroundColor(context.state.isBreak ? .orange : .red)
                    Text(context.state.isBreak ? "Break Time" : "Focus Time")
                        .font(.headline)
                }
                
                Text(context.state.taskName)
                    .font(.subheadline)
                
                Text(timeString(from: context.state.remainingTime))
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(context.state.isBreak ? .orange : .red)
                
                ProgressView(value: context.state.remainingTime, total: context.state.isBreak ? 300 : 1500)
                    .tint(context.state.isBreak ? .orange : .red)
            }
            .padding()
            .activityBackgroundTint(context.state.isBreak ? Color.orange.opacity(0.1) : Color.red.opacity(0.1))
            .activitySystemActionForegroundColor(context.state.isBreak ? .orange : .red)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading) {
                        Text(context.state.isBreak ? "Break" : "Focus")
                            .font(.headline)
                        Text(context.state.taskName)
                            .font(.subheadline)
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    Text(timeString(from: context.state.remainingTime))
                        .font(.title2)
                        .bold()
                }
                
                DynamicIslandExpandedRegion(.center) {
                    ProgressView(value: context.state.remainingTime, total: context.state.isBreak ? 300 : 1500)
                        .tint(context.state.isBreak ? .orange : .red)
                }
            } compactLeading: {
                Image(systemName: context.state.isBreak ? "cup.and.saucer.fill" : "timer")
                    .foregroundColor(context.state.isBreak ? .orange : .red)
            } compactTrailing: {
                Text(timeString(from: context.state.remainingTime))
                    .font(.caption2)
            } minimal: {
                Image(systemName: context.state.isBreak ? "cup.and.saucer.fill" : "timer")
                    .foregroundColor(context.state.isBreak ? .orange : .red)
            }
        }
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
} 