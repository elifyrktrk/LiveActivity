import WidgetKit
import SwiftUI

struct FintechWidget: Widget {
    let kind: String = "FintechWidget"
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FintechAttributes.self) { context in
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.green)
                    Text("Portfolio Status")
                        .font(.headline)
                }
                
                Text("$\(String(format: "%.2f", context.state.balance))")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.green)
                
                HStack {
                    Image(systemName: context.state.isPositive ? "arrow.up.right" : "arrow.down.right")
                    Text("\(String(format: "%.1f", context.state.changePercentage))%")
                }
                .foregroundColor(context.state.isPositive ? .green : .red)
                
                ProgressView(value: context.state.investmentProgress, total: 100)
                    .tint(.green)
            }
            .padding()
            .activityBackgroundTint(Color.green.opacity(0.1))
            .activitySystemActionForegroundColor(.green)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading) {
                        Text("Portfolio")
                            .font(.headline)
                        Text("$\(String(format: "%.2f", context.state.balance))")
                            .font(.subheadline)
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing) {
                        Text("\(String(format: "%.1f", context.state.changePercentage))%")
                            .font(.title2)
                            .bold()
                            .foregroundColor(context.state.isPositive ? .green : .red)
                    }
                }
                
                DynamicIslandExpandedRegion(.center) {
                    ProgressView(value: context.state.investmentProgress, total: 100)
                        .tint(.green)
                }
            } compactLeading: {
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundColor(.green)
            } compactTrailing: {
                Text("$\(String(format: "%.1f", context.state.balance))")
                    .font(.caption2)
            } minimal: {
                Image(systemName: "dollarsign.circle.fill")
                    .foregroundColor(.green)
            }
        }
    }
} 
