//
//  NumericKeyboard.swift
//  Money Keeper
//
//  Created by andromeda on 12/1/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

import UIKit

// public consts
let kDLNumericKeyboardRecommendedHeight = 240.0

// private consts
private let kDLNumericKeyboardNormalImage = UIImage(named: "numericKeyBackground")!
private let kDLNumericKeyboardPressedImage = UIImage(named: "pressedNumericKeyBackground")!

@objc protocol NumericKeyboardDelegate {
    func numericKeyPressed(key: Int)
    func numericHandlePressed(symbol: String)
    func numericSymbolPressed(symbol: String)
}

class NumericKeyboard: UIView {
    // MARK: - outlets
    // numbers
    @IBOutlet weak var buttonKey0: UIButton!
    @IBOutlet weak var buttonKey1: UIButton!
    @IBOutlet weak var buttonKey2: UIButton!
    @IBOutlet weak var buttonKey3: UIButton!
    @IBOutlet weak var buttonKey4: UIButton!
    @IBOutlet weak var buttonKey5: UIButton!
    @IBOutlet weak var buttonKey6: UIButton!
    @IBOutlet weak var buttonKey7: UIButton!
    @IBOutlet weak var buttonKey8: UIButton!
    @IBOutlet weak var buttonKey9: UIButton!
    @IBOutlet weak var buttonKeyDone: UIButton!
    
    // backspace
    @IBOutlet weak var buttonKeyBackspace: UIButton!
    @IBOutlet weak var buttonKeyClear: UIButton!
    
    // symbols
    @IBOutlet weak var buttonKeyPoint: UIButton!
    @IBOutlet weak var buttonKeyPlus: UIButton!
    @IBOutlet weak var buttonKeyMinus: UIButton!
    @IBOutlet weak var buttonKeyDevide: UIButton!
    @IBOutlet weak var buttonKeyMultiply: UIButton!
    @IBOutlet weak var buttonKeyEqual: UIButton!
    
    // all button outlets
    var allButtons: [UIButton] { return [buttonKey0, buttonKey1, buttonKey2, buttonKey3, buttonKey4, buttonKey5, buttonKey6, buttonKey7, buttonKey8, buttonKey9, buttonKeyDone, buttonKeyPlus, buttonKeyEqual, buttonKeyMinus, buttonKeyPoint, buttonKeyDevide, buttonKeyMultiply, buttonKeyBackspace] }
    
    // data
    weak var delegate: NumericKeyboardDelegate?
    
    // appearance variables
    var normalBackgroundImage = kDLNumericKeyboardNormalImage { didSet { updateButtonsAppearance() } }
    var pressedBackgroundImage = kDLNumericKeyboardPressedImage { didSet { updateButtonsAppearance() } }
    
    // MARK: - Initialization and lifecycle.
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeKeyboard()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeKeyboard()
    }
    
    func initializeKeyboard() {
        // set view
        let xibFileName = "NumericKeyboard"
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)![0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
        
        // set buttons appearance.
        updateButtonsAppearance()
    }
    
    // MARK: - Changes in appearance
    
    fileprivate func updateButtonsAppearance() {
        for button in allButtons {
            //button.setBackgroundImage(normalBackgroundImage, for: .normal)
            button.setBackgroundImage(pressedBackgroundImage, for: [.selected, .highlighted])
        }
    }
    
    // MARK: - Button actions
    @IBAction func numericButtonPressed(_ sender: UIButton) {
        self.delegate?.numericKeyPressed(key: sender.tag)
    }
    
    @IBAction func handlePressed(_ sender: UIButton) {
        let symbol = sender.titleLabel?.text ?? ""
        self.delegate?.numericHandlePressed(symbol: symbol)
    }
    
    @IBAction func symbolWasPressed(_ sender: UIButton) {
        if let symbol = sender.titleLabel?.text, symbol.characters.count > 0 {
            self.delegate?.numericSymbolPressed(symbol: symbol)
        }
    }
    
}
