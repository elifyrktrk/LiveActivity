import WidgetKit
import SwiftUI

struct FlightTrackingWidget: Widget {
    let kind: String = "FlightTrackingWidget"
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FlightTrackingAttributes.self) { context in
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "airplane")
                        .foregroundColor(.purple)
                    Text("Flight Tracking")
                        .font(.headline)
                }
                
                HStack {
                    Text(context.attributes.flightNumber)
                        .font(.subheadline)
                        .bold()
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(4)
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(context.attributes.departureCity)
                            .font(.caption)
                        Text(context.state.departureTime, style: .time)
                            .font(.subheadline)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text(context.attributes.arrivalCity)
                            .font(.caption)
                        Text(context.state.arrivalTime, style: .time)
                            .font(.subheadline)
                    }
                }
                
                HStack {
                    Image(systemName: "door.left.hand.open")
                        .foregroundColor(.purple)
                    Text("Gate \(context.state.gateNumber)")
                        .font(.caption)
                }
            }
            .padding()
            .activityBackgroundTint(Color.purple.opacity(0.1))
            .activitySystemActionForegroundColor(.purple)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading) {
                        Text(context.attributes.flightNumber)
                            .font(.headline)
                        Text("Gate \(context.state.gateNumber)")
                            .font(.subheadline)
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing) {
                        Text(context.state.departureTime, style: .time)
                            .font(.subheadline)
                        Text(context.state.arrivalTime, style: .time)
                            .font(.subheadline)
                    }
                }
                
                DynamicIslandExpandedRegion(.center) {
                    HStack {
                        Text(context.attributes.departureCity)
                        Image(systemName: "arrow.right")
                            .foregroundColor(.gray)
                        Text(context.attributes.arrivalCity)
                    }
                    .font(.caption)
                }
            } compactLeading: {
                Text(context.attributes.flightNumber)
                    .font(.caption2)
            } compactTrailing: {
                Text(context.state.departureTime, style: .time)
                    .font(.caption2)
            } minimal: {
                Image(systemName: "airplane")
                    .foregroundColor(.purple)
            }
        }
    }
} 
