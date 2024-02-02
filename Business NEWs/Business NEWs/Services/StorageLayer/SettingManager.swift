//
//  ThemeManager.swift
//  Business NEWs
//
//  Created by Mac on 11.09.2023.
//

import Foundation

protocol SettingManagerProtocol {
    var isDark: Bool { get set }
    var isNotify: Bool { get set }
    var language: Language { get set }
}

enum Language: String, CaseIterable {
    case deutsch = "de"
    case english = "en"
}

final class SettingManager: SettingManagerProtocol {
    private let userDefaults = UserDefaults.standard
    private let themeKey = "theme"
    private let notifyKey = "notify"
    private let languageKey = "language"
    
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
        set(environment) {
            userDefaults.set(environment.rawValue, forKey: languageKey)
        }
        get {
            let enviroment = userDefaults.value(forKey: languageKey) as? String
            return Language(rawValue: enviroment ?? "en")!
        }
        
    }
}
