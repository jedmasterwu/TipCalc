//
//  ViewController.swift
//  TipCalc
//
//  Created by Wuming Xie on 7/14/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    private let tipPercents = [0.15, 0.18, 0.2]
    private let currencyFormatter = NumberFormatter()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Update formatter currency locale
        currencyFormatter.locale = Locale.current
        currencyFormatter.numberStyle = .currency
    }
    
    override func viewDidLoad() {
        // Load default tip amount
        let defaults = UserDefaults.standard
        tipControl.selectedSegmentIndex = defaults.integer(forKey: Keys.segmentIndexKey)
        
        // Determine if last bill amount should be loaded
        if let lastActive = defaults.object(forKey: Keys.lastActiveKey) as? Date {
            if Date().timeIntervalSince(lastActive) < Constants.inactiveTime {
                billTextField.text = defaults.string(forKey: Keys.billAmountKey)
            }
        }
        
        // Update values
        updateValues()
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let defaults = UserDefaults.standard
        defaults.set(billTextField.text, forKey: Keys.billAmountKey)
        defaults.synchronize()
    }
    
    @IBAction func onMainViewTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        updateValues()
    }
    
    private func updateValues() {
        let billTotal = Double(billTextField.text!) ?? 0.0
        let tip = billTotal * tipPercents[tipControl.selectedSegmentIndex]
        
        tipLabel.text = currencyFormatter.string(for: tip)
        totalLabel.text = currencyFormatter.string(for: billTotal + tip)
    }
}

