import ActivityKit
import Foundation
import NetmeraLiveActivity
//bu kalsın app targeta eklenecek Live Activity . Bu kısım Dökümanda da belirtilecek sağ taraftaki Target Membership alanını kırmızı alan içine al
// MARK: - Match Score Activity
//NetmeraLiveActivityAttributes group id için zorunlu ekletiyoruz
struct MatchScoreAttributes: ActivityAttributes, NetmeraLiveActivityAttributes {
    var netmeraGroupId: String?
    var homeTeamName: String
    var awayTeamName: String
    var homeTeamLogo: String
    var awayTeamLogo: String
    
    public static var activityIdentifier: String = "MatchScoreAttributes"
    
    public struct ContentState: Codable, Hashable {
        var homeTeamScore: Int
        var awayTeamScore: Int
        var minute: Int
       
    }
}

// MARK: - Delivery Tracking Activity
struct DeliveryTrackingAttributes: ActivityAttributes, NetmeraLiveActivityAttributes {
    var netmeraGroupId: String?
    
    public static var activityIdentifier: String = "DeliveryTrackingAttributes"
    
    public struct ContentState: Codable, Hashable {
        var deliveryStatus: String
        var remainingStops: Int
        var estimatedDeliveryTime: Date
        var courierName: String
    }
}

// MARK: - Public Transport Activity
struct PublicTransportAttributes: ActivityAttributes, NetmeraLiveActivityAttributes {
    var netmeraGroupId: String?
    
    public static var activityIdentifier: String = "PublicTransportAttributes"
    
    public struct ContentState: Codable, Hashable {
        var vehicleNumber: String
        var remainingTime: Int // in minutes
        var stopName: String
        var vehicleType: String // "bus" or "train"
    }
}

// MARK: - Flight Tracking Activity
struct FlightTrackingAttributes: ActivityAttributes , NetmeraLiveActivityAttributes {
    var netmeraGroupId: String?
    var flightNumber: String
    var arrivalCity: String
    var airlineLogo: String
    var departureCity: String
    
    public static var activityIdentifier: String = "FlightTrackingAttributes"
    
    public struct ContentState: Codable, Hashable {
        
        var departureTime: Date
        var arrivalTime: Date
        var gateNumber: String
        
    }
}

// MARK: - Pomodoro Timer Activity
//Alternatif başka bir örnek ekleyebilirim. 
struct PomodoroAttributes: ActivityAttributes , NetmeraLiveActivityAttributes {
    var netmeraGroupId: String?
    var taskName: String
    
    public static var activityIdentifier: String = "PomodoroAttributes"
    
    
    public struct ContentState: Codable, Hashable {
        var remainingTime: TimeInterval
        var isBreak: Bool
    }
}
