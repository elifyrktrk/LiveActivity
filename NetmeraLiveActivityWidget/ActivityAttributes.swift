import ActivityKit
import Foundation
import NetmeraLiveActivity
// ActivityAttributes yapısını tanımladığınız dosyada, sağ panelde bulunan “Target Membership” alanına dikkat edilmelidir.
// Bu dosya, hem ana uygulama (main app) target’ına hem de Widget Extension target’ına dahil edilmelidir.
// Xcode’da bu işlem, dosya seçiliyken sağ tarafta “Target Membership” kutularından ilgili target’ların işaretlenmesiyle yapılır.
// Aksi halde Widget, bu struct'a erişemez ve derleme hatası alınabilir.

// MARK: - Match Score Activity

struct MatchScoreAttributes: ActivityAttributes, NetmeraLiveActivityAttributes {
    // NetmeraLiveActivityAttributes group id için zorunlu ekletiyoruz
    // `netmeraGroupId` alanı zorunludur ve her activity için benzersiz bir değer atanmalıdır.
    // Bu ID, Netmera'nın farklı kullanıcılara gönderilen aynı activity’leri gruplaması ve tek bir istek ile birden fazla userda aynı group idli activitynin güncellenmesini sağlar.

    var netmeraGroupId: String?
    var homeTeamName: String
    var awayTeamName: String
    var homeTeamLogo: String
    var awayTeamLogo: String
    
    public static var activityIdentifier: String = "MatchScoreAttributes"
    
    public struct ContentState: Codable, Hashable {
        var homeTeamScore: Int
        var awayTeamScore: Int
        var matchStatus: String
       
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


struct FintechAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var balance: Double
        var changePercentage: Double
        var isPositive: Bool
        var investmentProgress: Double
    }
} 

