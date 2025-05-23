# Netmera Live Activity Sample

This project demonstrates how to use iOS Live Activities with Netmera integration. The project includes examples for different scenarios:

- Match Score Tracking
- Delivery Tracking
- Public Transport Tracking
- Flight Tracking
- Financial Tracking
  
<p align="center">
  <img src="https://github.com/user-attachments/assets/916a362f-27d0-4f05-832b-59cde9e5537e" width="160"/>
  <img src="https://github.com/user-attachments/assets/37cc4dbe-52fe-4f07-a8f2-c4ca85164b87" width="160"/>
  <img src="https://github.com/user-attachments/assets/ff4d7ca2-532a-4fe9-aacd-01961810f4f2" width="160"/>
  <img src="https://github.com/user-attachments/assets/178d0869-8fd8-4483-be81-a60b44d6c544" width="160"/>
  <img src="https://github.com/user-attachments/assets/5e19ae76-cf87-4d2b-9ff8-2ed57d2d277c" width="160"/>
</p>

  

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

```xml
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
            "awayTeamName": "Liverpool",
            "homeTeamLogo": "barcelona_logo",
            "awayTeamLogo": "madrid_logo"
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

```xml
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

```xml
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

Each Live Activity requires a custom widget design. 

## Debugging

1. **Error**: "🔴 - [LiveActivityManagerImpl.swift] Cannot observe activity, missing required attribute: netmeraGroupId" error occurs when `netmeraGroupId` is missing.




