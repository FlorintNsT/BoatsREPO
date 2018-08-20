//
//  NotificationService.swift
//  Boats
//
//  Created by Absolute Mac on 08/08/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import Foundation
import UserNotifications
class NotificationService {//: UNUserNotificationCenterDelegate{
    
    
    func showNotif(withTitle titleText: String,withMessage contentText: String){
        
        let content = UNMutableNotificationContent()
        
        //adding title, subtitle, body and badge
        content.title = titleText
        //content.subtitle = "iOS Development is fun"
        content.body = contentText
        content.badge = 1
         content.setValue("YES", forKeyPath: "shouldAlwaysAlertWhileAppIsForeground") //Update is here
        //getting the notification trigger
        //it will be called after 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        
        //getting the notification request
        let request = UNNotificationRequest(identifier: "SimplifiedIOSNotification", content: content, trigger: trigger)
        
     //   UNUserNotificationCenter.current().delegate = self
        
        //adding the notification to notification center
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        })

    }
    
    
}
