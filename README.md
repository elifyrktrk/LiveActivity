# Netmera Live Activity Sample

This project demonstrates how to use iOS Live Activities with Netmera integration. The project includes examples for different scenarios:

- Match Score Tracking
- Delivery Tracking
- Public Transport Tracking
- Flight Tracking
- Financial Tracking

## Requirements

- iOS 17.2 or later
- Xcode 14.1 or later
- Netmera SDK
- Apple Developer account (required for Live Activities)

## Configuration

### Info.plist Settings

Required Info.plist settings for the main app:

```xml
<key>NSSupportsLiveActivities</key>
<true/>
<key>NSSupportsLiveActivitiesFrequentUpdates</key>
<true/>
<key>UIBackgroundModes</key>
<array>
    <string>remote-notification</string>
</array>
<key>NSUserActivityTypes</key>
<array>
    <string>MatchScoreAttributes</string>
    <string>DeliveryTrackingAttributes</string>
    <string>PublicTransportAttributes</string>
    <string>FlightTrackingAttributes</string>
    <string>FintechAttributes</string>
</array>
```

Required Info.plist settings for the Widget Extension:

```xml
<key>NSSupportsLiveActivities</key>
<true/>
<key>NSSupportsLiveActivitiesFrequentUpdates</key>
<true/>
```

## Live Activity Usage

### 1. Activity Attributes Definition

Each Live Activity requires a custom `ActivityAttributes` structure. Example:

```swift
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
        var matchStatus: String
    }
}
```

### 2. Activity Registration

For iOS 17.2 and later, Live Activities must be registered with Netmera for tracking:

```swift
@available(iOS 17.2, *)
func registerForMatchScoreActivity() {
    Netmera.register(forType: Activity<MatchScoreAttributes>.self, name: "MatchScoreAttributes")
}
```

### 3. Start a Live Activity Remotely via Netmera REST API

```
curl --location 'https://restapi.netmera.com/rest/3.0/sendBulkNotification' \
--header 'X-netmera-api-key: your_rest_api_key' \
--header 'Content-Type: application/json' \
--data '{
    "message": {
        "title": "Live Activity Start",
        "text": "Here your live activity",
        "platforms": [
            "IOS"
        ],
        "contentState": {
            "homeTeamScore": 0,
            "awayTeamScore": 0,
            "matchStatus": "1st Half"
        },
        "liveActAttr": {
            "netmeraGroupId": "ars-liv-2025",
            "homeTeamName": "Arsenal",
            "awayTeamName": "Liverpool"
            
        },
        "liveActAttrType": "MatchScoreAttributes"
    },
    "type": "LIVE_ACTIVITY",
    "target": {
        "sendToAll": true
    }
}'
```

### 4. Update a Live Activity Remotely via Netmera REST API

```
curl --location 'https://restapi.netmera.com/rest/3.0/update-live-activity' \
--header 'X-netmera-api-key: your_rest_api_key' \
--header 'Content-Type: application/json' \
--data '{
    "groupId": "Barcelona-R.Madrid",
    "action": "UPDATE",
    "contentState": {
        "homeTeamScore": 1,
        "awayTeamScore": 0,
        "matchStatus": "2nd Half"
    },
    "priority": 10
}'
```

### 5. End a Live Activity Remotely via Netmera's REST API

```
curl --location 'https://restapi.netmera.com/rest/3.0/update-live-activity' \
--header 'X-netmera-api-key: your_rest_api_key' \
--header 'Content-Type: application/json' \
--data '{
    "groupId": "fb-gs",
    "action": "END",
    "priority": 10
}'

```

## Important Notes

1. **netmeraGroupId**: A unique group ID must be assigned for each activity. This ID allows Netmera to group the same activities sent to different users.

2. **Local Start**: For Live Activities started locally by the app, the `Netmera.observeActivity(_:)` method must be called.

3. **Update Timing**: Updates should not be made immediately after starting an activity. A minimum wait time of 1 minute is recommended for the first update.

4. **Activity End**: For activities manually ended by the user, the `Netmera.resumeObservingActivities(ofType:)` method should be called when the app is reopened.

## Widget Design

Each Live Activity requires a custom widget design. Example widget structure:

```swift
struct MatchScoreWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MatchScoreAttributes.self) { context in
            // Widget UI design
        } dynamicIsland: { context in
            DynamicIsland {
                // Dynamic Island expanded view
            } compactLeading: {
                // Compact leading view
            } compactTrailing: {
                // Compact trailing view
            } minimal: {
                // Minimal view
            }
        }
    }
}
```

## Debugging

1. **Token Error**: "Cannot observe activity, missing required attribute: netmeraGroupId" error occurs when `netmeraGroupId` is missing.

## Supported Scenarios

1. **Match Score Tracking**
   - Team names and logos
   - Live score
   - Match status

2. **Delivery Tracking**
   - Delivery status
   - Remaining stops
   - Estimated delivery time
   - Courier information

3. **Public Transport Tracking**
   - Vehicle number
   - Remaining time
   - Stop name
   - Vehicle type

4. **Flight Tracking**
   - Flight number
   - Departure/arrival time
   - Departure/arrival city
   - Gate number
   - Airline logo

5. **Financial Tracking**
   - Balance
   - Change percentage
   - Investment progress


