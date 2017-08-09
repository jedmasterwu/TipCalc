//
//  ViewController.swift
//  TipCalc
//
//  Created by Wuming Xie on 7/14/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

class TipViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet var allLabels: [UILabel]!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var billView: UIView!
    @IBOutlet weak var resultsView: UIView!

    // MARK: Properties
    private let defaults = UserDefaults.standard
    private let currencyFormatter = NumberFormatter()
    private var tipPercents = [15, 18, 20]
    private var theme = Theme.normal
    private var suggestedTipRows: [String: UILabel] = [String: UILabel]()
    
    private var billOrigin: CGFloat = 0
    private var resultsOrigin: CGFloat = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Update formatter currency locale
        currencyFormatter.locale = Locale.current
        currencyFormatter.numberStyle = .currency
    }

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for label in allLabels {
            if let accessibilityLabel = label.accessibilityLabel {
                suggestedTipRows[accessibilityLabel] = label
            }
        }
        
        // Change settings button to an icon
        settingsButton.title = "\u{f085}"
        settingsButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "FontAwesome", size: 18.0)!], for: .normal)
        settingsButton.tintColor = UIColor.black
        
        // Store bill text view origin
        billOrigin = billTextField.frame.origin.y
        resultsOrigin = resultsView.frame.origin.x
        billTextField.contentVerticalAlignment = .center
        Utils.addDoneButtonOnKeyboard(target: self, selector: #selector(TipViewController.onMainViewTap), textField: billTextField)
        
        // Load default tip amount
        if let storePercents = defaults.array(forKey: Keys.suggestedTipsKey) as? [Int] {
            tipPercents = storePercents
        }

        // Determine if last bill amount should be loaded
        if let lastActive = defaults.object(forKey: Keys.lastActiveKey) as? Date {
            if Date().timeIntervalSince(lastActive) < Constants.inactiveTime {
                billTextField.text = defaults.string(forKey: Keys.billAmountKey)
            }
        }

        // Update values
        updateValues()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        theme = ThemeManager.getCurrentTheme()
        updateColors()
        billTextField.becomeFirstResponder()
        
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateViews(false)
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
        updateViews(true)
    }
    
    private func updateValues() {
        let _ = Double(billTextField.text!) ?? 0.0
    }

    private func updateColors() {
        mainView.backgroundColor = theme.bgColor
        mainView.tintColor = theme.tintColor
        billView.backgroundColor = theme.bgColor
        resultsView.backgroundColor = theme.bgColor
        billTextField.backgroundColor = theme.bgColor
        billTextField.keyboardAppearance = theme == .dark ? .dark : .light
        billTextField.tintColor = theme.tintColor
        billTextField.textColor = theme.textColor
        if let doneBar = billTextField.inputAccessoryView {
            doneBar.backgroundColor = theme.bgColor
            doneBar.tintColor = theme.tintColor
        }
        
        for label in allLabels {
            label.textColor = theme.textColor
        }
    }

    private func showInputOnly() {
        billTextField.frame.origin.y = billView.frame.origin.y
        resultsView.frame.origin.x -= 2000
        resultsView.alpha = 0.0
    }
    
    private func showAll() {
        billTextField.frame.origin.y = billView.frame.origin.y + billView.frame.height * 0.25
        resultsView.frame.origin.x = resultsOrigin
        resultsView.alpha = 1.0
    }
    
    private func showInputOnly(_ animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.5, animations: {
                self.showInputOnly()
            })
        } else {
            showInputOnly()
        }
    }
    
    private func showAll(_ animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.5, animations: { self.showAll()
            })
        } else {
            showAll()
        }
    }
    
    private func updateViews(_ animated: Bool) {
        let billAmount = Double(billTextField.text!) ?? 0.0
        if billAmount == 0.0 {
            showInputOnly(animated)
        } else {
            showAll(animated)
        }
    }
}
