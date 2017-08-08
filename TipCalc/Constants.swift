//
//  Keys.swift
//  TipCalc
//
//  Created by Wuming Xie on 7/16/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

struct Keys {
    static let lastActiveKey = "last_active_time"
    static let billAmountKey = "saved_bill_amount"
    static let suggestedTipsKey = "suggested_tip_percentages"
    static let themeKey = "selected_theme"
    static let tipCalc = "tip_calculator"
}

struct Constants {
    static let inactiveTime = 600.0
    static let tipSettingNames = ["Tip percent low", "Tip percent low", "Tip percent high"]
    static let themeSettingName = "Dark theme"
    static let settingsFont = UIFont(name: "HelveticaNeue", size: 20.0)
}
