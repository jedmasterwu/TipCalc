//
//  Theme.swift
//  TipCalc
//
//  Created by Wuming Xie on 7/17/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

enum Theme: Int {
    case normal, dark
    
    var tintColor: UIColor {
        switch self {
        case .normal:
            return UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        case .dark:
            return UIColor(red: 90.0/255.0, green: 200.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .normal:
            return .darkText
        case .dark:
            return .lightText
        }
    }
    
    var bgColor: UIColor {
        switch self {
        case .normal:
            return .white
        case .dark:
            return .darkGray
        }
    }
}

struct ThemeManager {
    static func getCurrentTheme() -> Theme {
        return Theme(rawValue: UserDefaults.standard.integer(forKey: Keys.themeKey))!
    }
    
    static func storeTheme(_ theme: Theme) {
        let defaults = UserDefaults.standard
        defaults.set(theme.rawValue, forKey: Keys.themeKey)
        defaults.synchronize()
    }
}
