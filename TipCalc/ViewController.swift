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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let index = UserDefaults.standard.integer(forKey: SettingsViewController.segmentIndexKey)
        tipControl.selectedSegmentIndex = index
        super.viewWillAppear(animated)
        updateValues()
        print("view will appear")
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
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", billTotal + tip)
    }
}

