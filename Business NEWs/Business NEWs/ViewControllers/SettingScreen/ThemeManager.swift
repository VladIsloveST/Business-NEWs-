//
//  ThemeManager.swift
//  Business NEWs
//
//  Created by Mac on 11.09.2023.
//

import Foundation

protocol ThemeManagerProtocol {
    static var shared: ThemeManagerProtocol { get }
    var isDark: Bool { get set }
}

final class ThemeManager: ThemeManagerProtocol {
    static let shared: ThemeManagerProtocol = ThemeManager()
    private let userDefaults = UserDefaults.standard
    private let themeKey = "themeKey"
    private init() {}
    
    var isDark: Bool {
        set {
            userDefaults.set(newValue, forKey: themeKey)
        }
        get {
            userDefaults.bool(forKey: themeKey)
        }
    }
}
