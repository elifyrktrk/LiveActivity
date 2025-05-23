//
//  LiveActivityManager.swift
//  NetmeraLiveActivitySample
//
//  Created by Elif Yürektürk on 23.05.2025.
//

import NetmeraLiveActivity
import NetmeraCore
import ActivityKit


class LiveActivityManager {
    // iOS 17.2 ve üzeri sürümlerde Live Activity takibi için Netmera'ya register işlemi yapılmalıdır.
    // Bu işlem sayesinde Netmera, belirli bir Activity türüne ait tokenları dinlemeye başlar.
    // register(forType:name:) metodu, AppDelegate içerisindeki application(_:didFinishLaunchingWithOptions:)
    // metodunda ya da uygulamanın herhangi bir yerinde çağırılabilir. register çağrısından sonra Netmera tokenları dinlemeye başlar.
    // Bu örnekte LiveActivityManager'da kullanıyoruz

    // Dikkat edilmesi gereken bir diğer nokta da şudur:
    // register işlemi gerçekleştirildikten sonra, ilgili Live Activity için start işlemi yapılır.
    // Start işleminden hemen sonra update çağrılmamalıdır. İlk güncelleme için minimum 1 dakikalık bir bekleme süresi önerilir.
  @available(iOS 17.2, *)
  func registerActivityType() {
          Netmera.register(forType: Activity<MatchScoreAttributes>.self, name: "MatchScoreAttributes")
  }

}
