//
//  CalendarCell.swift
//  Money Keeper
//
//  Created by andromeda on 12/6/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarCell: JTAppleCell {
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblIncome: UILabel!
    @IBOutlet weak var lblExpense: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 0.5
        self.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
}
