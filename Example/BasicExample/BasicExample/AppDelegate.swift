//
//  AppDelegate.swift
//  BasicExample
//
//  Created by Deepa on 26/12/22.
//

import UIKit
import Segment
import Segment_MoEngage
import MoEngageSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
        
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        let sdkConfig = MoEngageSDKConfig(withAppID: "DAO6UGZ73D9RTK8B5W96TPYN")
        sdkConfig.moeDataCenter = MoEngageDataCenter.data_center_01
        sdkConfig.appGroupID = "group.com.alphadevs.MoEngage.NotificationServices"
        sdkConfig.enableLogs = true
        
        MoEngageInitializer.shared.initializeDefaultInstance(sdkConfig: sdkConfig)
        MoEngage.sharedInstance.enableSDK()
        
        MoEngageSDKMessaging.sharedInstance.registerForRemoteNotification(withCategories: nil, andUserNotificationCenterDelegate: self)
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Analytics.main.registeredForRemoteNotifications(deviceToken: deviceToken)
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        Analytics.main.receivedRemoteNotification(userInfo: userInfo)
    }

}

extension Analytics {
    static var main: Analytics {
        MoEngageSegmentInitializer.shared.initializeSegmentAnalytics(writeKey: "6XjfktaG0LXHRwwn1quJwlW1Lo2Ol6WJ")
        return MoEngageSegmentInitializer.shared.analytics
    }
}
