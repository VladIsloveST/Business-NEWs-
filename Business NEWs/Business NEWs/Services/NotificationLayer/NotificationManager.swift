//
//  LocalNotification.swift
//  Business NEWs
//
//  Created by Mac on 30.07.2023.
//

import Foundation
import NotificationCenter

protocol NotificationManagerProtocol {
    func checkForPermission()
    func directToSettings(_ completionHandler: @escaping UndefinedAction)
    func reopenNotification(language: Language)
    func removeNotification()
}


@objc
class NotificationManager: NSObject, NotificationManagerProtocol {
    private let notificationCenter = UNUserNotificationCenter.current()
    weak var delegate: SettingsDelegate?
    
    func checkForPermission() {
        notificationCenter.delegate = self
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                self.scheduleNotification()
            case .notDetermined:
                self.requestAuthorization()
            default:
                return
            }
        }
    }
    
    private func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) { [weak self] (granted, error) in
            guard granted, error != nil else { return }
            self?.delegate?.setValueIsNotify()
            self?.scheduleNotification()
        }
    }
    
    func directToSettings(_ completionHandler: @escaping UndefinedAction) {
        notificationCenter.getNotificationSettings { settings in
            guard settings.alertSetting == .disabled,
                  let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.setValueIsNotify()
                completionHandler()
                UIApplication.shared.open(settingsURL)
            }
        }
    }
    
    private func scheduleNotification() {
        let identifier = "notification"
        let title = "News"
        let body = "10 articles on the topic of Business were published"
        let isDaily = true
        let content = UNMutableNotificationContent(title: title, body: body, sound: .default)
        let dateComponents = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current,
                                            hour: 19, minute:  42)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        notificationCenter.add(request) { error in
            print(error?.localizedDescription as Any)
        }
    }
    
    func reopenNotification(language: Language) {
        let identifier = "reopen"
        let title = "Language changed to ".localized + "\(language)"
        let body = "Tap to reopen the application".localized
        let content = UNMutableNotificationContent(title: title, body: body, sound: .default)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        notificationCenter.add(request) { error in
            print(error?.localizedDescription as Any)
        }
    }
    
    func removeNotification() {
        notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.removeAllDeliveredNotifications()
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, 
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let id = notification.request.identifier
        print(#function, "Notification ID = \(id)")
        completionHandler([.list, .banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, 
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let id = response.notification.request.identifier
        print(#function, "Notification ID = \(id)")
        completionHandler()
    }
}
