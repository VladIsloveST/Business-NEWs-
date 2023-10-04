//
//  LocalNotification.swift
//  Business NEWs
//
//  Created by Mac on 30.07.2023.
//

import Foundation
import NotificationCenter

protocol LocalNotificatioProtocol {
    func checkForPermission()
    func removeNotification()
    func directToSettings(_ completionHandler: @escaping UndefinedAction)
    func reopenNotification(language: Language)
}


@objc
class LocalNotification: NSObject, LocalNotificatioProtocol {
    private let notificationCenter = UNUserNotificationCenter.current()
    weak var delegate: SettingsDelegate?
    
    func checkForPermission() {
        notificationCenter.delegate = self
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.notificationCenter.requestAuthorization(options: [.alert, .sound]) { [weak self] (granted, error) in
                    guard error == nil else { return }
                    if granted {
                        self?.delegate?.setValue(isNotify: true)
                        self?.dispatchNotification()
                    }
                }
            case .authorized:
                self.dispatchNotification()                
            default:
                return
            }
        }
    }
    
    func removeNotification() {
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    func directToSettings(_ completionHandler: @escaping UndefinedAction) {
        notificationCenter.getNotificationSettings { settings in
            if settings.alertSetting == .disabled {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    DispatchQueue.main.async { [weak self] in
                        self?.delegate?.setValue(isNotify: true)
                        completionHandler()
                        UIApplication.shared.open(settingsURL)
                    }
                }
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
                                            hour: 19, minute:  42)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        notificationCenter.add(request) { error in
            print(error?.localizedDescription as Any)
            print("???")
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
