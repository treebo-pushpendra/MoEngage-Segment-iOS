//
//  NotificationViewController.swift
//  NotificationContent
//
//  Created by Rakshitha on 14/02/22.
//  Copyright © 2022 Prateek Srivastava. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import MoEngageRichNotification

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MORichNotification.setAppGroupID("group.com.alphadevs.MoEngage.NotificationServices")
    }
    
    func didReceive(_ notification: UNNotification) {
        MORichNotification.addPushTemplate(toController: self, withNotification: notification)
    }

}
