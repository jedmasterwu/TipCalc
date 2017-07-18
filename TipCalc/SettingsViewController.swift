//
//  SettingsViewController.swift
//  TipCalc
//
//  Created by Wuming Xie on 7/14/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var defaultTipController: UISegmentedControl!
    @IBOutlet weak var themeSwitch: UISwitch!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet var mainView: UIView!
    
    private var theme = Theme.normal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultTipController.selectedSegmentIndex = UserDefaults.standard.integer(forKey: Keys.segmentIndexKey)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        theme = ThemeManager.getCurrentTheme()
        themeSwitch.isOn = theme == .dark
        updateColors()
        
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func updateDefaultTip(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.set(defaultTipController.selectedSegmentIndex, forKey: Keys.segmentIndexKey)
        defaults.synchronize()
    }
    
    @IBAction func updateTheme(_ sender: Any) {
        self.theme = themeSwitch.isOn ? .dark : .normal
        ThemeManager.storeTheme(self.theme)
        updateColors()
    }
    
    private func updateColors() {
        mainView.backgroundColor = theme.bgColor
        mainView.tintColor = theme.tintColor
        
        themeLabel.textColor = theme.textColor
        tipLabel.textColor = theme.textColor
        themeSwitch.tintColor = theme.tintColor
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
