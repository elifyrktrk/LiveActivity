import WidgetKit
import SwiftUI

struct DeliveryTrackingWidget: Widget {
    let kind: String = "DeliveryTrackingWidget"
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DeliveryTrackingAttributes.self) { context in
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "shippingbox.fill")
                        .foregroundColor(.blue)
                    Text("Delivery Tracking")
                        .font(.headline)
                }
                
                Text("Courier: \(context.state.courierName)")
                    .font(.subheadline)
                
                Text("Status: \(context.state.deliveryStatus)")
                    .font(.subheadline)
                
                HStack {
                    Text("\(context.state.remainingStops) stops remaining")
                        .font(.caption)
                    Spacer()
                    Text("ETA: \(context.state.estimatedDeliveryTime, style: .time)")
                        .font(.caption)
                }
                
                ProgressView(value: Double(5 - context.state.remainingStops), total: 5)
                    .tint(.blue)
            }
            .padding()
            .activityBackgroundTint(Color.blue.opacity(0.1))
            .activitySystemActionForegroundColor(.blue)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    VStack(alignment: .leading) {
                        Text("Delivery Status")
                            .font(.headline)
                        Text(context.state.deliveryStatus)
                            .font(.subheadline)
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    VStack(alignment: .trailing) {
                        Text("\(context.state.remainingStops) stops left")
                            .font(.subheadline)
                        Text("ETA: \(context.state.estimatedDeliveryTime, style: .time)")
                            .font(.caption)
                    }
                }
                
                DynamicIslandExpandedRegion(.center) {
                    ProgressView(value: Double(5 - context.state.remainingStops), total: 5)
                        .tint(.blue)
                }
            } compactLeading: {
                Image(systemName: "shippingbox.fill")
                    .foregroundColor(.blue)
            } compactTrailing: {
                Text("\(context.state.remainingStops) stops")
                    .font(.caption2)
            } minimal: {
                Image(systemName: "shippingbox.fill")
                    .foregroundColor(.blue)
            }
        }
    }
} 