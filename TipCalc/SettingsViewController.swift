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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultTipController.selectedSegmentIndex = UserDefaults.standard.integer(forKey: Keys.segmentIndexKey)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
