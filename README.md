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
- Netmera SDK 4.2.0 or later
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


## Step 1: Activity Attributes Definition
ActivityAttributes: This protocol defines the static (unchanging) and dynamic (changing) content that will be displayed in the Live Activity.
ActivityAttributes.ContentState: This type defines the dynamic data that will be updated throughout the lifecycle of the activity.

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

## Step 2: Start the Activity

First, choose how you want to register your activity:

**Remote**: Use the `Netmera.register()` method early in your user lifecycle and before the push-to-start token is needed,  
then start an activity using the `/rest/3.0/sendBulkNotification` endpoint.

```swift
 Netmera.register(forType: Activity<MatchScoreAttributes>.self, name: "MatchScoreAttributes")
```

**Local**: If the Live Activity is started locally (not via Netmera), you must inform Netmera so it can track and manage the activity lifecycle.  
To do this, call the following method **right after starting your activity**:

```swift
 Netmera.observeActivity(matchActivity)
```

###  Activity Registration

For iOS 17.2 and later, Live Activities must be registered with Netmera for tracking:

```swift
@available(iOS 17.2, *)
func registerForMatchScoreActivity() {
    Netmera.register(forType: Activity<MatchScoreAttributes>.self, name: "MatchScoreAttributes")
}
```

###  Start a Live Activity Remotely via Netmera REST API

The following example demonstrates how to start a Live Activity on iOS devices via Netmera's `sendBulkNotification` endpoint.  
In this example, the Live Activity represents a football match score update.

### 📌 Key Parameters

| Parameter             | Description |
|-----------------------|-------------|
| `type`                | Must be `"LIVE_ACTIVITY"` to activate the Live Activity feature. |
| `contentState`        | Contains dynamic values that can be updated throughout the activity (e.g. score, match status). |
| `liveActAttr`         | Contains static metadata used in the widget. All fields are required. |
| `netmeraGroupId`      | A unique ID that groups the same activity across different users. |
| `homeTeamName`        | Name of the home team to be displayed in the widget. |
| `awayTeamName`        | Name of the away team to be displayed. |
| `homeTeamLogo`        | Media identifier for the home team logo. |
| `awayTeamLogo`        | Media identifier for the away team logo. |
| `liveActAttrType`     | Must match the name of your `ActivityAttributes` Swift class/struct. |
| `sendToAll`           | Set to `true` to broadcast the activity to all users. You can replace this with custom targeting if needed. |

> ⚠️ All fields inside `liveActAttr` are mandatory. Missing any of them (e.g., `awayTeamLogo`) will cause the request to fail and the Live Activity will not be shown.

---
#### Sample Request
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


## Step 3: Resume Activity Tracking

To ensure Netmera continues tracking Live Activities when the app is reopened:

- If a Live Activity that was started locally is manually ended by the user,  
its connection with the app is lost. Therefore, when the app is relaunched,  
the activity must be observed again to restore tracking.

This should be handled inside the `application(_:didFinishLaunchingWithOptions:)` method of your `AppDelegate`.  
Doing so ensures that both locally and remotely started activities are properly re-observed on app launch.

```swift
Netmera.resumeObservingActivities(ofType: Activity<MatchScoreAttributes>.self)
```

### Example

```swift
import UIKit
import NetmeraLiveActivity
import ActivityKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        Netmera.initialize()
        Netmera.setLogLevel(.debug) // Options: .debug, .info, .error, .fault
        // Use .debug mode to view detailed Netmera logs
        
        Netmera.requestPushNotificationAuthorization(for: [.alert, .badge, .sound])
        UNUserNotificationCenter.current().delegate = self // Set the delegate for the notification center

        let liveActivityManager = LiveActivityManager()
        liveActivityManager.registerForMatchScoreActivity()
        
        if #available(iOS 16.1, *) {
            Netmera.resumeObservingActivities(ofType: Activity<MatchScoreAttributes>.self)
        }

        return true
    }
}
```

## Step 4:  Update a Live Activity Remotely via Netmera REST API

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

## Step 5:  End a Live Activity Remotely via Netmera's REST API

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
## 🛑 Unregistering a Live Activity

You can stop tracking a specific Live Activity using the `Netmera.unregister(name:)` method.

#### 📌 Example Use Case:
When a user removes a football match from their favorites, and no longer wants to see updates on the lock screen or widget, you should call:

```swift
Netmera.unregister(name: matchActivity)
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




