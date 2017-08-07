//
//  ViewController.swift
//  TipCalc
//
//  Created by Wuming Xie on 7/14/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

class TipViewController: UIViewController {
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var billTextField: UITextField!
    @IBOutlet weak var suggestedLabel: UILabel!
    @IBOutlet weak var percentColumnLabel: UILabel!
    @IBOutlet weak var tipPercentLabel1: UILabel!
    @IBOutlet weak var tipPercentLabel2: UILabel!
    @IBOutlet weak var tipPercentLabel3: UILabel!
    @IBOutlet weak var tipColumnLabel: UILabel!
    @IBOutlet weak var tipAmountLabel1: UILabel!
    @IBOutlet weak var tipAmountLabel2: UILabel!
    @IBOutlet weak var tipAmountLabel3: UILabel!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var billView: UIView!
    @IBOutlet weak var resultsView: UIView!

    private let tipPercents = [0.15, 0.18, 0.2]
    private let currencyFormatter = NumberFormatter()
    private var theme = Theme.normal
    
    private var billOrigin: CGFloat = 0
    private var resultsOrigin: CGFloat = 0
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Update formatter currency locale
        currencyFormatter.locale = Locale.current
        currencyFormatter.numberStyle = .currency
    }

    override func viewDidLoad() {
        // Change settings button to an icon
        settingsButton.title = "\u{f085}"
        settingsButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "FontAwesome", size: 18.0)!], for: .normal)
        settingsButton.tintColor = UIColor.black
        
        // Store bill text view origin
        billOrigin = billTextField.frame.origin.y
        resultsOrigin = resultsView.frame.origin.x
        billTextField.contentVerticalAlignment = .center
        TipViewController.addDoneButtonOnKeyboard(target: self, selector: #selector(TipViewController.calculateTip), textField: billTextField)
        
        // Load default tip amount
        // TODO: add default tip amounts
        let defaults = UserDefaults.standard
        

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
        view.endEditing(true)
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
        if let doneBar = billTextField.inputAccessoryView {
            doneBar.backgroundColor = theme.bgColor
            doneBar.tintColor = theme.tintColor
        }
        
        billTextField.textColor = theme.textColor
        suggestedLabel.textColor = theme.textColor
        percentColumnLabel.textColor = theme.textColor
        tipColumnLabel.textColor = theme.textColor
        tipPercentLabel1.textColor = theme.textColor
        tipPercentLabel2.textColor = theme.textColor
        tipPercentLabel3.textColor = theme.textColor
        tipAmountLabel1.textColor = theme.textColor
        tipAmountLabel2.textColor = theme.textColor
        tipAmountLabel3.textColor = theme.textColor
    }

    private func showInputOnly() {
        billTextField.frame.origin.y = billView.frame.origin.y
        resultsView.frame.origin.x -= 2000
        resultsView.alpha = 0.0
    }
    
    private func showAll() {
        billTextField.frame.origin.y = billOrigin
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
    
    public static func addDoneButtonOnKeyboard(target: Any?, selector: Selector?, textField: UITextField) {
        let doneToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: .done, target: target, action: selector)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        textField.inputAccessoryView = doneToolbar
    }
}

