import WidgetKit
import SwiftUI

struct PublicTransportWidget: Widget {
    let kind: String = "PublicTransportWidget"
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PublicTransportAttributes.self) { context in
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: context.state.vehicleType == "bus" ? "bus.fill" : "tram.fill")
                        .foregroundColor(.green)
                    Text("Public Transport")
                        .font(.headline)
                }
                
                Text("Vehicle: \(context.state.vehicleNumber)")
                    .font(.subheadline)
                
                Text("Stop: \(context.state.stopName)")
                    .font(.subheadline)
                
                HStack {
                    Image(systemName: "clock.fill")
                        .foregroundColor(.green)
                    Text("Match Status \(context.state.remainingTime) ")
                        .font(.caption)
                }
            }
            .padding()
            .activityBackgroundTint(Color.green.opacity(0.1))
            .activitySystemActionForegroundColor(.green)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading) {
                        Text(context.state.vehicleNumber)
                            .font(.headline)
                        Text(context.state.stopName)
                            .font(.subheadline)
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing) {
                        Text("Arriving in")
                            .font(.caption)
                        Text("\(context.state.remainingTime) min")
                            .font(.subheadline)
                            .bold()
                    }
                }
                
                DynamicIslandExpandedRegion(.center) {
                    Image(systemName: context.state.vehicleType == "bus" ? "bus.fill" : "tram.fill")
                        .foregroundColor(.green)
                }
            } compactLeading: {
                Image(systemName: context.state.vehicleType == "bus" ? "bus.fill" : "tram.fill")
                    .foregroundColor(.green)
            } compactTrailing: {
                Text("\(context.state.remainingTime)m")
                    .font(.caption2)
            } minimal: {
                Image(systemName: context.state.vehicleType == "bus" ? "bus.fill" : "tram.fill")
                    .foregroundColor(.green)
            }
        }
    }
} 
