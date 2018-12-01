//
//  UITextfield+NumericKeyboard.swift
//  Money Keeper
//
//  Created by andromeda on 12/1/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

import UIKit

private var numericKeyboardDelegate: NumericKeyboardDelegate? = nil

extension UITextField: NumericKeyboardDelegate {
    // MARK: - Public methods to set or unset this uitextfield as NumericKeyboard.
    
    func setAsNumericKeyboard(delegate: NumericKeyboardDelegate?) {
        let numericKeyboard = NumericKeyboard(frame: CGRect(x: 0, y: 0, width: 0, height: kDLNumericKeyboardRecommendedHeight))
        self.inputView = numericKeyboard
        numericKeyboardDelegate = delegate
        numericKeyboard.delegate = self
    }
    
    func unsetAsNumericKeyboard() {
        if let numericKeyboard = self.inputView as? NumericKeyboard {
            numericKeyboard.delegate = nil
        }
        self.inputView = nil
        numericKeyboardDelegate = nil
    }
    
    // MARK: - NumericKeyboardDelegate methods
    
    internal func numericKeyPressed(key: Int) {
        if key == 0 && self.text?.isEmpty == true{
            return
        }
        self.text?.append("\(key)")
        numericKeyboardDelegate?.numericKeyPressed(key: key)
    }
    
    internal func numericHandlePressed(symbol: String) {
        if var text = self.text, text.characters.count > 0 {
            _ = text.remove(at: text.index(before: text.endIndex))
            self.text = text
        }
        numericKeyboardDelegate?.numericHandlePressed(symbol: symbol)
    }
    
    internal func numericSymbolPressed(symbol: String){
        let sym = symbol.first
        guard self.text?.last != sym else{
            return
        }
        
        numericKeyboardDelegate?.numericSymbolPressed(symbol: symbol)
    }
}

extension String{
    func isOperator()->Bool{
        guard self.lowercased() != "+" && self.lowercased() != "-" && self.lowercased() != "x" && self.lowercased() != "/" else{
            return true
        }
        return false
    }
    
    func isHavePointInNumber(){
        
    }
}
