//
//  UITextfield+NumericKeyboard.swift
//  Money Keeper
//
//  Created by andromeda on 12/1/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

import UIKit
import Expression

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
    
    //0...9
    internal func numericKeyPressed(key: Int) {
        if key == 0 && self.text?.isEmpty == true{
            return
        }
        self.text?.append("\(key)")
        numericKeyboardDelegate?.numericKeyPressed(key: key)
    }
    
    private func caculator() -> String{
        if var text = self.text, text.count > 0{
            var double:Double? = nil
            while text.count > 0{
                double = Double(Expression(text).description)
                if double != nil{
                    return "\(double!)"
                }
                text.removeLast()
            }
        }
        return "0"
    }
    
    //clear, backspace, done, =
    internal func numericHandlePressed(symbol: String) {
        if symbol == "Done"{//hide keyboard
            self.endEditing(true)
            self.text = caculator()
            return
        }
        
        if symbol == "="{//caculator
            self.text = caculator()
            return
        }
        if var text = self.text , text.characters.count > 0 {
            if symbol == "C"{//clear textfield
                self.text = ""
            }else{//is backspace
                _ = text.remove(at: text.index(before: text.endIndex))
                self.text = text
            }
        }
        
        defer{
            numericKeyboardDelegate?.numericHandlePressed(symbol: symbol)
        }
    }
    
    //+, -, *, /, .
    internal func numericSymbolPressed(symbol: String){
        if let text = self.text, text.count > 0{
            
            guard let opera = symbol.first else{
                return
            }
            
            let lastText = text.last!
            if opera.isOperator(){//is operator
                if lastText.isOperator() == true{
                    guard lastText != opera else{
                        return
                    }
                    _ = self.text?.removeLast()
                }else if lastText == "."{
                    _ = self.text?.removeLast()
                    if let temp = self.text?.last{
                        if temp.isOperator() == true{
                            _ = self.text?.removeLast()
                        }
                    }
                }
            }else{//is point
                guard text.isHavePointInLastNumber() == false else{
                    return
                }
            }
        }else if symbol == "/" || symbol == "*"{
            return
        }
        
        self.text?.append(symbol)
        
        defer{
            numericKeyboardDelegate?.numericSymbolPressed(symbol: symbol)
        }
    }
}

extension Character{
    func isOperator()->Bool{
        guard self != "+" && self != "-" && self != "*" && self != "/" else{
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
