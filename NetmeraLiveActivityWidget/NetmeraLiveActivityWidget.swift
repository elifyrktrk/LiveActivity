//
//  NetmeraLiveActivityWidget.swift
//  NetmeraLiveActivityWidget
//
//  Created by Elif Yürektürk on 21.05.2025.
//

import WidgetKit
import SwiftUI

@main
struct NetmeraLiveActivityWidget: WidgetBundle {
    var body: some Widget {
        MatchScoreWidget()
        DeliveryTrackingWidget()
        PublicTransportWidget()
        FlightTrackingWidget()
        FintechWidget()
    }
}
