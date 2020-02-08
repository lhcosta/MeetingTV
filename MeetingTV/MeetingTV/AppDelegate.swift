//
//  AppDelegate.swift
//  MeetingTV
//
//  Created by Bernardo Nunes on 21/11/19.
//  Copyright © 2019 Bernardo Nunes. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let userNotCenter = UNUserNotificationCenter.current()
        userNotCenter.delegate = self
        
        userNotCenter.requestAuthorization(options: [.providesAppNotificationSettings], completionHandler: { (permission, error) in
            print("===>\(permission)/\(error.debugDescription)")
        })
        
        DispatchQueue.main.async {
            application.registerForRemoteNotifications()
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // Saves changes in the application's managed object context when the application transitions to the background.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        guard let CKnotification = CKQueryNotification(fromRemoteNotificationDictionary: userInfo) else { return }
        guard let recordID = CKnotification.recordID else { return }
        guard let keys = CKnotification.recordFields else { return }
        
        var updatedTopic = keys
        updatedTopic["recordName"] = recordID.recordName
        NotificationCenter.default.post(name: NSNotification.Name("topicUpdate"), object: updatedTopic)
    }
}

