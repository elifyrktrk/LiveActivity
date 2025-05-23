# Netmera Live Activity Sample

This project demonstrates how to use iOS Live Activities with Netmera integration. The project includes examples for different scenarios:

- Match Score Tracking
- Delivery Tracking
- Public Transport Tracking
- Flight Tracking
- Financial Tracking
  
![IMG_9227](https://github.com/user-attachments/assets/ac5c5784-442f-4e50-adbb-05c654558ba5)
![IMG_9228](https://github.com/user-attachments/assets/b5973021-ef0d-42bd-a2c1-f4c41a1af9ef)
![IMG_9229](https://github.com/user-attachments/assets/6b008000-12c9-4695-9335-7a7459ec1d04)
![IMG_9230](https://github.com/user-attachments/assets/97ee5822-8cd6-401f-9e96-e12652c45164)
![IMG_9231](https://github.com/user-attachments/assets/037cb910-f332-482e-a5aa-f76ac7784a91)

  

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

Each Live Activity requires a custom widget design. 

## Debugging

1. **Error**: "Cannot observe activity, missing required attribute: netmeraGroupId" error occurs when `netmeraGroupId` is missing.




