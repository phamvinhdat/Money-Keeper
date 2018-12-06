//
//  CalendarViewController.swift
//  Money Keeper
//
//  Created by andromeda on 12/6/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController, UITextFieldDelegate {
    let datePicker = UIDatePicker()
    let dateFormat = DateFormatter()
    
    @IBOutlet weak var txtDate: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTxtDay_viewDidLoad()
        setDatePicker_viewDidLoad()
    }
    
    //MASK: todo
    @objc func dateChanged(DatePicker: UIDatePicker){
        dateFormat.dateFormat = "EEEE, yyyy/MM/dd"
        txtDate.text = dateFormat.string(from: DatePicker.date)
    }
    
    @objc func viewTapped(){
        view.endEditing(true)
    }
    
    func setDatePicker_viewDidLoad(){
        
        datePicker.addTarget(self, action: #selector(InputViewController.dateChanged(DatePicker:)), for: .valueChanged)
    }
    
    func setTxtDay_viewDidLoad(){
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "EEEE, yyyy/MM/dd"
        txtDate.text = dateFormat.string(from: Date())
        txtDate.textAlignment = .center
        txtDate.inputView = datePicker
        txtDate.delegate = self
        txtDate.resignFirstResponder()
    }

}

extension CalendarViewController: JTAppleCalendarViewDataSource{
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        dateFormat.dateFormat = "dd MM yyyy"
        dateFormat.timeZone = Calendar.current.timeZone
        dateFormat.locale = Calendar.current.locale
        let startDate = dateFormat.date(from: "01 01 1970")!
        let endDate = dateFormat.date(from: "31 12 2999")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 5, calendar: Calendar.current, generateInDates: .forAllMonths, generateOutDates: .tillEndOfGrid, firstDayOfWeek: .monday, hasStrictBoundaries: nil)
        
        return parameters
    }
    
    
}

extension CalendarViewController: JTAppleCalendarViewDelegate{
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        //todo
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        
        cell.lblDay.text = cellState.text
        return cell
    }
    
    
}
