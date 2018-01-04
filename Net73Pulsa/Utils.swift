//
//  Utils.swift
//  Net73Pulsa
//
//  Created by Eka Putra on 1/3/18.
//  Copyright © 2018 Eka Putra. All rights reserved.
//

import UIKit

class Utils {
    
    // Clean phone number
    // example: +62 81747 65123 --> 08174765123
    static func cleanPhoneNumber(for number: String) -> String {
        let cleanedNumber = number.replacingOccurrences(of: "+62", with: "0")
                                  .replacingOccurrences(of: "-", with: "")
        return cleanedNumber.components(separatedBy: .whitespaces).joined(separator: "")
    }
    
    // Show UIAlertController with single button
    static func createSingleActionAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
}

