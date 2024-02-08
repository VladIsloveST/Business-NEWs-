//
//  NSLocalizedString.swift
//  Business NEWs
//
//  Created by Mac on 24.09.2023.
//

import Foundation

extension String {
    var localized: String {
        let language = SettingManager().language.rawValue
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
              let bundle = Bundle(path: path) else { return "en" }
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
}
