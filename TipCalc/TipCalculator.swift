//
//  TipCalculator.swift
//  TipCalc
//
//  Created by Wuming Xie on 8/4/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import Foundation

class TipCalculator {
    private var billAmount = 0.0
    private var suggestedTips = [15, 18, 20]
    private let defaults = UserDefaults.standard
    private let currencyFormatter = NumberFormatter()
    
    init() {
        currencyFormatter.locale = Locale.current
        currencyFormatter.numberStyle = .currency
    }
    
    public func setBillAmount(billAmount: String?) {
        self.billAmount = Double(billAmount!) ?? 0.0
    }
    
    public func getBillAmount() -> Double {
        return self.billAmount
    }
    
    public func saveCalculator() {
        defaults.set(self, forKey: Keys.tipCalc)
        defaults.synchronize()
    }
    
    public func calculate() {
        
    }
}
