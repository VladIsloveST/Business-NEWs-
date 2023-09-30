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
    var language: Language { get set }
}

enum Language: String, CaseIterable {
    case deutsch = "de"
    case english = "en"
}

final class SettingManager: SettingManagerProtocol {
    static var shared: SettingManagerProtocol = SettingManager()
    private let userDefaults = UserDefaults.standard
    private let themeKey = "theme"
    private let notifyKey = "notify"
    private let languageKey = "language"
    private init() {}
    
    var isDark: Bool {
        set {
            userDefaults.set(newValue, forKey: themeKey) }
        get {
            userDefaults.bool(forKey: themeKey) }
    }
    
    var isNotify: Bool {
        set {
            userDefaults.set(newValue, forKey: notifyKey) }
        get {
            userDefaults.bool(forKey: notifyKey) }
    }
    
    var language: Language {
        get {
            let enviroment = userDefaults.value(forKey: languageKey) as? String ?? "en"
            return Language(rawValue: enviroment)!
        }
        set(environment) {
            userDefaults.set(environment.rawValue, forKey: languageKey)
            userDefaults.synchronize()
        }
    }
}
