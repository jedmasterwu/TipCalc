//
//  Utils.swift
//  TipCalc
//
//  Created by Wuming Xie on 8/8/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

class Utils {
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
