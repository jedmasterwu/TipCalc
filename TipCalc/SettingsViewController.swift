//
//  SettingsViewController.swift
//  TipCalc
//
//  Created by Wuming Xie on 7/14/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    let tipCategory = ["low", "mid", "high"]
    let defaults = UserDefaults.standard
    var tipPercentages = [15, 18, 20]
    var theme = Theme.normal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.register(TipCell.self, forCellReuseIdentifier: "tipCell")
        tableView.register(ThemeCell.self, forCellReuseIdentifier: "themeCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadTheme()
        loadTips()
        updateColor(darkThemeOn: theme == .dark)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.settingsCellHeight
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tipPercentages.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsCell
        if indexPath.row < tipPercentages.count {
            cell = tableView.dequeueReusableCell(withIdentifier: "tipCell", for: indexPath) as! SettingsCell
            let tipCell = cell as! TipCell
            tipCell.updateText(row: indexPath.row)
            tipCell.updateTip(tipPercentages[indexPath.row])
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "themeCell", for: indexPath) as! SettingsCell
            let themeCell = cell as! ThemeCell
            themeCell.updateSwitch(theme == .dark)
        }
        cell.selectionStyle = .none
        cell.settingsViewController = self
        return cell
    }
    
    func tipChanged(row: Int, newTipPercentage: Int) {
        if newTipPercentage > 0 {
            var needsUpdating = true
            for i in 0..<tipPercentages.count {
                if newTipPercentage == tipPercentages[i] {
                    needsUpdating = false
                    break
                }
            }
            
            if needsUpdating {
                tipPercentages[row] = newTipPercentage
                tipPercentages.sort()
                saveTips()
            }
            
        }
        
        for i in 0..<tipPercentages.count {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! TipCell
            cell.updateTip(tipPercentages[i])
        }
    }
    
    func updateColor(darkThemeOn: Bool) {
        theme = darkThemeOn ? .dark : .normal
        saveTheme()
        view.backgroundColor = theme.bgColor
        for i in 0..<(tipPercentages.count + 1) {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! SettingsCell
            cell.updateColors(theme)
        }
    }
    
    private func loadTheme() {
        theme = defaults.bool(forKey: Keys.themeKey) ? .dark : .normal
    }
    
    private func loadTips() {
        if let storePercentages = defaults.array(forKey: Keys.suggestedTipsKey) as? [Int] {
            tipPercentages = storePercentages
        }
    }
    
    private func saveTheme() {
        defaults.set(theme == .dark, forKey: Keys.themeKey)
        defaults.synchronize()
    }
    
    private func saveTips() {
        defaults.set(tipPercentages, forKey: Keys.suggestedTipsKey)
    }
    
    static func createSettingCellView(cell: UITableViewCell, v0: UIView, v1: UIView) {
        cell.addSubview(v0)
        cell.addSubview(v1)
        
        cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[v0]-8-[v1(60)]-16-|",
                                                      options: NSLayoutFormatOptions(),
                                                      metrics: nil,
                                                      views: ["v0": v0, "v1": v1]))
        cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|",
                                                      options: NSLayoutFormatOptions(),
                                                      metrics: nil,
                                                      views: ["v0": v0]))
        cell.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[v1]-8-|",
                                                      options: NSLayoutFormatOptions(),
                                                      metrics: nil,
                                                      views: ["v1": v1]))
    }
}

class SettingsCell: UITableViewCell {
    let settingNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var settingsViewController: SettingsViewController?
    
    func updateColors(_ theme: Theme) {
        backgroundColor = theme.bgColor
        settingNameLabel.textColor = theme.textColor
    }
}

class TipCell: SettingsCell {
    var tipField: UITextField = {
        let field = UITextField()
        field.font = Constants.settingsFont
        field.clearsOnBeginEditing = true
        field.translatesAutoresizingMaskIntoConstraints = false
        field.textAlignment = .center
        field.keyboardType = .decimalPad
        return field
    }()
    var rowNum: Int?
    var tipPercent: Int?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        Utils.addDoneButtonOnKeyboard(target: self, selector: #selector(TipCell.updateTipPercentages), textField: tipField)
        tipField.addTarget(self, action: #selector(TipCell.updateTipPercentages), for: .editingDidEnd)
        SettingsViewController.createSettingCellView(cell: self, v0: settingNameLabel, v1: tipField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateColors(_ theme: Theme) {
        super.updateColors(theme)
        tipField.textColor = theme.textColor
        tipField.keyboardAppearance = (theme == .dark) ? .dark : .light
    }
    
    func updateText(row: Int) {
        settingNameLabel.text = Constants.tipSettingNames[row]
        rowNum = row
    }
    
    func updateTip(_ tipPercentage: Int) {
        self.tipPercent = tipPercentage
        tipField.text = String(tipPercentage)
    }
    
    func updateTipPercentages() {
        settingsViewController!.view.endEditing(true)
        let newPercentage = Int(tipField.text!) ?? 0
        settingsViewController?.tipChanged(row: rowNum!, newTipPercentage: newPercentage)
    }
}

class ThemeCell: SettingsCell {
    let themeSwitch = UISwitch()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        settingNameLabel.text = Constants.themeSettingName
        themeSwitch.translatesAutoresizingMaskIntoConstraints = false
        themeSwitch.addTarget(self, action: #selector(ThemeCell.updateTheme), for: .valueChanged)
        SettingsViewController.createSettingCellView(cell: self, v0: settingNameLabel, v1: themeSwitch)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateSwitch(_ isDarkMode: Bool) {
        themeSwitch.isOn = isDarkMode
    }
    
    func updateTheme() {
        settingsViewController?.updateColor(darkThemeOn: themeSwitch.isOn)
    }
}
