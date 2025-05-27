<<<<<<< HEAD
# Netmera Live Activity Sample

Live Activities enable apps to display dynamic, real-time updates directly on glanceable areas like the Lock Screen, iPhone StandBy, Dynamic Island, and Apple Watch's Smart Stack, allowing users to monitor ongoing events, activities, or tasks without constantly reopening the app.

Ideal for tracking short-to-medium-length tasks, Live Activities present prioritized information such as live sports scores, delivery updates, or fitness metrics, and can offer interactive options for user control. For best practices, ensure a concise layout suited to all display locations, avoid sensitive information, and refrain from using Live Activities for advertising, preserving them as a tool for useful, timely updates.

## Netmera and Live Activities

To facilitate this feature, Netmera has integrated additional functionalities into the existing message delivery framework specifically designed for Live Activity.

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
- Swift SDK version 4.2.0 or higher
- p8 push certificate
- iOS 17.2 and above (for remote Live Activity initiation)

## Setup Steps

### 1. Info.plist Configuration
```xml
<key>NSSupportsLiveActivities</key>
<true/>
<key>NSSupportsLiveActivitiesFrequentUpdates</key>
<true/>
```

### 2. ActivityAttributes Structure
```swift
import Foundation
import ActivityKit
import NetmeraLiveActivity

struct MatchScoreAttributes: ActivityAttributes, NetmeraLiveActivityAttributes {
    var netmeraGroupId: String? // Required and must be unique
    
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

**Important Note:** The ActivityAttributes file must be included in both the main app target and widget extension target.

### 3. Live Activity Registration
```swift
if #available(iOS 17.2, *) {
    Netmera.register(forType: Activity<MatchScoreAttributes>.self, name: "MatchScoreAttributes")
}
```

### 4. Starting Live Activity

#### Remote Start (iOS 17.2+)
```swift
// Register the activity type first (Step 3)
// Then use Netmera REST API to start the activity
```

#### Local Start
```swift
let attributes = MatchScoreAttributes(
    netmeraGroupId: "unique-id",
    homeTeamName: "Home Team",
    awayTeamName: "Away Team",
    homeTeamLogo: "logo1",
    awayTeamLogo: "logo2"
)

let contentState = MatchScoreAttributes.ContentState(
    homeTeamScore: 0,
    awayTeamScore: 0,
    matchStatus: "1st Half"
)

let activity = try Activity.request(
    attributes: attributes,
    contentState: contentState,
    pushType: .token
)

Netmera.observeActivity(activity)
```

### 5. Activity Tracking on App Relaunch
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    Netmera.initialize()
    
    if #available(iOS 16.1, *) {
        Netmera.resumeObservingActivities(ofType: Activity<MatchScoreAttributes>.self)
    }
    return true
}
```

### 6. REST API Usage

#### Update Live Activity
```json
{
    "groupId": "unique-id",
    "action": "UPDATE",
    "contentState": {
        "homeTeamScore": 1,
        "awayTeamScore": 0,
        "matchStatus": "2nd Half"
    },
    "priority": 10
}
```

#### End Live Activity
```json
{
    "groupId": "unique-id",
    "action": "END",
    "priority": 10
}
```

### 7. Unregistering Activity
```swift
Netmera.unregister(name: activityName)
```

## Debugging
If you encounter the error "`Cannot observe activity, missing required attribute: netmeraGroupId`", ensure that netmeraGroupId is properly defined in your ActivityAttributes structure.

## Important Notes
- Live Activities are ideal for short to medium-term tasks
- Avoid displaying sensitive information
- Do not use for advertising purposes
- Use a concise layout suitable for all display areas
=======

>>>>>>> 89dfd9ebcb73caee673f0366ef54a107e9d9b66e

