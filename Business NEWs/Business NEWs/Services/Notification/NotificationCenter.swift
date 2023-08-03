//
//  LocalNotification.swift
//  Business NEWs
//
//  Created by Mac on 30.07.2023.
//

import Foundation
import NotificationCenter

@objc
class LocalNotification: NSObject {
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    func checkForPermission() {
        notificationCenter.delegate = self
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.notificationCenter.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                    guard error == nil else { return }
                    if granted {
                        self.dispatchNotification()
                    }
                }
            case .authorized:
                self.dispatchNotification()
            default:
                return
            }
        }
    }
    
    private func dispatchNotification() {
        let identifier = "notification"
        let title = "News"
        let body = "10 articles on the topic of Business were published"
        let isDaily = true
        let content = UNMutableNotificationContent(title: title, body: body, sound: .default)
        let dateComponents = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current,
                                            hour: 22, minute:  41)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        notificationCenter.add(request) { error in
            print(error?.localizedDescription as Any)
        }
    }
}

extension LocalNotification: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner, .sound])
        print(#function)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(#function)
    }
}
