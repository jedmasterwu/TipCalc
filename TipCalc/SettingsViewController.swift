//
//  SettingsViewController.swift
//  TipCalc
//
//  Created by Wuming Xie on 7/14/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    @IBOutlet weak var settingsTable: UITableView!
    @IBOutlet weak var tipLowLabel: UILabel!
    @IBOutlet weak var tipMidLabel: UILabel!
    @IBOutlet weak var tipHighLabel: UILabel!
    @IBOutlet weak var tipLowTextField: UITextField!
    @IBOutlet weak var tipMidTextField: UITextField!
    @IBOutlet weak var tipHighTextField: UITextField!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var themeSwitch: UISwitch!
    
    private var theme = Theme.normal
    private var suggestedTips = [15, 18, 20]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let storedTips = UserDefaults.standard.object(forKey: Keys.suggestedTipsKey) {
            suggestedTips = storedTips as! [Int]
        }
        TipViewController.addDoneButtonOnKeyboard(target: self, selector: #selector(SettingsViewController.updateSuggestedTips), textField: tipLowTextField)
        TipViewController.addDoneButtonOnKeyboard(target: self, selector: #selector(SettingsViewController.updateSuggestedTips), textField: tipMidTextField)
        TipViewController.addDoneButtonOnKeyboard(target: self, selector: #selector(SettingsViewController.updateSuggestedTips), textField: tipHighTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        theme = ThemeManager.getCurrentTheme()
        themeSwitch.isOn = theme == .dark
        updateColors()
        updateValues()
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updateTheme(_ sender: Any) {
        self.theme = themeSwitch.isOn ? .dark : .normal
        ThemeManager.storeTheme(self.theme)
        updateColors()
    }
    
    @IBAction func updateSuggestedTips(_ sender: Any) {
        view.endEditing(true)
        let tipLow = Int(tipLowTextField.text!) ?? suggestedTips[0]
        let tipMid = Int(tipMidTextField.text!) ?? suggestedTips[1]
        let tipHigh = Int(tipHighTextField.text!) ?? suggestedTips[2]
        
        let newTips = [tipLow, tipMid, tipHigh]
        if Set(newTips).count == 3 {
            suggestedTips = newTips.sorted()
            saveSuggestedTips()
        }
        updateValues()
    }
    
    private func updateColors() {
        settingsTable.backgroundColor = theme.bgColor
        settingsTable.backgroundView?.backgroundColor = theme.bgColor
        for i in 0..<settingsTable.numberOfRows(inSection: 0) {
            if let cell = settingsTable.cellForRow(at: IndexPath(row: i, section: 0)) {
                cell.backgroundColor = theme.bgColor
            }
        }
        tipLowLabel.textColor = theme.textColor
        tipLowTextField.textColor = theme.textColor
        tipMidLabel.textColor = theme.textColor
        tipMidTextField.textColor = theme.textColor
        tipHighLabel.textColor = theme.textColor
        tipHighTextField.textColor = theme.textColor
        themeLabel.textColor = theme.textColor
    }
    
    private func updateValues() {
        tipLowTextField.text = String(suggestedTips[0])
        tipMidTextField.text = String(suggestedTips[1])
        tipHighTextField.text = String(suggestedTips[2])
    }
    
    private func saveSuggestedTips() {
        let defaults = UserDefaults.standard
        defaults.set(suggestedTips, forKey: Keys.suggestedTipsKey)
        defaults.synchronize()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
