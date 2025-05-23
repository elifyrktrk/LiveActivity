//
//  AppDelegate.swift
//  NetmeraLiveActivity
//
//  Created by Elif Yürektürk on 20.05.2025.
//

import UIKit
import CoreData
import NetmeraAnalytic
import NetmeraNotification
import NetmeraLocation
import NetmeraNotificationInbox
import NetmeraAdvertisingId
import NetmeraLiveActivity
import ActivityKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Netmera.initialize()
        Netmera.setLogLevel(.debug) // Options: .debug, .info, .error, .fault
        // Use .debug mode to view detailed Netmera logs
        // Set the delegate for the notification center
        Netmera.requestPushNotificationAuthorization(for: [.alert, .badge, .sound])
        UNUserNotificationCenter.current().delegate = self
        
        let liveActivityManager = LiveActivityManager()
        liveActivityManager.registerForMatchScoreActivity()
        
        // sil
        let user = NetmeraUser()
        user.userId = "elif"
        Netmera.updateUser(user: user)
        
        // iOS 17.2 ve üzeri sürümlerde Live Activity takibi için Netmera'ya register işlemi yapılmalıdır.
        // Bu işlem sayesinde Netmera, belirli bir Activity türüne ait tokenları dinlemeye başlar.
        // register(forType:name:) metodu, AppDelegate içerisindeki application(_:didFinishLaunchingWithOptions:)
        // metodunda ya da uygulamanın herhangi bir yerinde çağırılabilir. register çağrısından sonra Netmera tokenları dinlemeye başlar.
        // (LiveActivityManager yazıp o şekilde dene)

        // Dikkat edilmesi gereken bir diğer nokta da şudur:
        // register işlemi gerçekleştirildikten sonra, ilgili Live Activity için start işlemi yapılır.
        // Start işleminden hemen sonra update çağrılmamalıdır. İlk güncelleme için minimum 1 dakikalık bir bekleme süresi önerilir.
//        if #available(iOS 17.2, *) {
//            Netmera.register(forType: Activity<MatchScoreAttributes>.self, name: "MatchScoreAttributes")
//        }
        
        

  
        
        // Local olarak başlatılan bir Live Activity, kullanıcı tarafından manuel olarak sonlandırıldığında
        // uygulama ile olan bağlantısı kesilir. Bu durumda, uygulama tekrar açıldığında ilgili activity’yi
        // yeniden observe (izleme) işlemi yapılmalıdır.

        // Bu işlem, AppDelegate içerisindeki application(_:didFinishLaunchingWithOptions:) metodunda çağrılmalıdır.
        // Böylece hem local başlatılan activity’ler hem de uzaktan (remote) başlatılan activity’ler yeniden izlenebilir hale gelir.

        // Bu adım, özellikle remote başlatılan activity’ler için kritik öneme sahiptir ve mutlaka dökümana dahil edilmelidir.

        // Eğer bu metot çağrılmazsa, kullanıcı bir activity’yi manuel olarak sonlandırdığında
        // Netmera bu durumu fark edemez ve ilgili token’lar backend’de birikmeye devam eder.
        // Bu da gereksiz token yığılmasına ve performans sorunlarına yol açabilir.

        // Bu nedenle, bir activity sonlandırıldığında onunla ilişkili token’ın da temizlenebilmesi için
        // bu metot mutlaka kullanılmalıdır.
        Netmera.resumeObservingActivities(ofType: Activity<MatchScoreAttributes>.self)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Display the notification
        if #available(iOS 14.0, *) {
            // Use .banner and .list for iOS 14 and later
            completionHandler([.banner, .list, .badge, .sound])
        } else {
            // Use .alert for earlier versions of iOS
            completionHandler([.alert, .badge, .sound])
        }
    }

    // Handle user interaction with notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "NetmeraLiveActivity")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

