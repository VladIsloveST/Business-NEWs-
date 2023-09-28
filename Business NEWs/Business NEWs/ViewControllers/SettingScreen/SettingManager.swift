//
//  ThemeManager.swift
//  Business NEWs
//
//  Created by Mac on 11.09.2023.
//

import Foundation

protocol SettingManagerProtocol {
    static var shared: SettingManagerProtocol { get }
    var isDark: Bool { get set }
    var isNotify: Bool { get set }
}

final class SettingManager: SettingManagerProtocol {
    static var shared: SettingManagerProtocol = SettingManager()
    private let userDefaults = UserDefaults.standard
    private let themeKey = "themeKey"
    private let notifyKey = "notifyKey"
    private init() {}
    
    var isDark: Bool {
        set {
            userDefaults.set(newValue, forKey: themeKey)
        }
        get {
            userDefaults.bool(forKey: themeKey)
        }
    }
    
    var isNotify: Bool {
        set {
            userDefaults.set(newValue, forKey: notifyKey)
        }
        get {
            userDefaults.bool(forKey: notifyKey)
        }
    }
}
