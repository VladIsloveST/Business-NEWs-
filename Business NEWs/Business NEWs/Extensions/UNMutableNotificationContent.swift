//
//  UNMutableNotificationContent.swift
//  Business NEWs
//
//  Created by Mac on 30.07.2023.
//

import Foundation
import NotificationCenter

extension UNMutableNotificationContent  {
    convenience init(title: String, body: String, sound: UNNotificationSound) {
        self.init()
        self.title = title
        self.body = body
        self.sound = .default
    }
}
