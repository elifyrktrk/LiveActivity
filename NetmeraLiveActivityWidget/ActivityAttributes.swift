import ActivityKit
import Foundation

// MARK: - Match Score Activity
struct MatchScoreAttributes: ActivityAttributes {
    public static var activityIdentifier: String = "MatchScoreAttributes"
    
    public struct ContentState: Codable, Hashable {
        var homeTeamScore: Int
        var awayTeamScore: Int
        var minute: Int
        var homeTeamName: String
        var awayTeamName: String
    }
}

// MARK: - Delivery Tracking Activity
struct DeliveryTrackingAttributes: ActivityAttributes {
    public static var activityIdentifier: String = "DeliveryTrackingAttributes"
    
    public struct ContentState: Codable, Hashable {
        var deliveryStatus: String
        var remainingStops: Int
        var estimatedDeliveryTime: Date
        var courierName: String
    }
}

// MARK: - Public Transport Activity
struct PublicTransportAttributes: ActivityAttributes {
    public static var activityIdentifier: String = "PublicTransportAttributes"
    
    public struct ContentState: Codable, Hashable {
        var vehicleNumber: String
        var remainingTime: Int // in minutes
        var stopName: String
        var vehicleType: String // "bus" or "train"
    }
}

// MARK: - Flight Tracking Activity
struct FlightTrackingAttributes: ActivityAttributes {
    public static var activityIdentifier: String = "FlightTrackingAttributes"
    
    public struct ContentState: Codable, Hashable {
        var flightNumber: String
        var departureTime: Date
        var arrivalTime: Date
        var departureCity: String
        var arrivalCity: String
        var gateNumber: String
    }
}

// MARK: - Pomodoro Timer Activity
struct PomodoroAttributes: ActivityAttributes {
    public static var activityIdentifier: String = "PomodoroAttributes"
    
    public struct ContentState: Codable, Hashable {
        var remainingTime: TimeInterval
        var taskName: String
        var isBreak: Bool
    }
} 