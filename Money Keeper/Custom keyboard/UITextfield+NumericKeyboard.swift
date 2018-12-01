//
//  UITextfield+NumericKeyboard.swift
//  Money Keeper
//
//  Created by andromeda on 12/1/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

import UIKit

private var numericKeyboardDelegate: NumericKeyboardDelegate? = nil

extension UITextField: NumericKeyboardDelegate{
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
        if symbol == "Done"{
            self.endEditing(true)
            print("done")
        }
        if var text = self.text , text.characters.count > 0 {
            if symbol == "C"{
                self.text = ""
            }else if symbol == "="{
                
            }else{//is backspace
                _ = text.remove(at: text.index(before: text.endIndex))
                self.text = text
            }
        }
        numericKeyboardDelegate?.numericHandlePressed(symbol: symbol)
    }
    
    internal func numericSymbolPressed(symbol: String){
        
        if var text = self.text, text.characters.count > 0 {
            let sym = symbol.first
            let lastCh = text.last
            
            guard lastCh != sym else{
                return
            }
            
            if sym == "." && self.text?.isHavePointInLastNumber() == true{
                return
            }
            
            if lastCh?.isOperator() == true{
                _ = text.remove(at: text.index(before: text.endIndex))
                self.text = text
            }
            self.text?.append(symbol)
        }
        numericKeyboardDelegate?.numericSymbolPressed(symbol: symbol)
    }
}

extension Character{
    func isOperator()->Bool{
        guard self != "+" && self != "-" && self != "x" && self != "/" else{
            return true
        }
        return false
    }
}

extension String{

    func isHavePointInLastNumber()->Bool{
        var str = self
        while str.isEmpty == false && str.last?.isOperator() == false{
            if str.last == "."{
                return true
            }
            _ = str.popLast()
        }
        return false
    }
}
