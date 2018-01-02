//
//  UINumberInput.swift
//  Net73Pulsa
//
//  Created by Eka Putra on 1/2/18.
//  Copyright © 2018 Eka Putra. All rights reserved.
//

import UIKit

@IBDesignable
class UINumberInput: UITextField {

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 0, dy: 10)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}
