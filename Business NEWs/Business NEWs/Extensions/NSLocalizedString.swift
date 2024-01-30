//
//  NSLocalizedString.swift
//  Business NEWs
//
//  Created by Mac on 24.09.2023.
//

import Foundation

extension String {
    var localized: String {
        let language = UserDefaults.standard.value(forKey: "language") as? String
        let path = Bundle.main.path(forResource: language ?? "en", ofType: "lproj")
        let bundle = Bundle(path: path ?? Bundle.main.bundlePath)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
