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
    var tableViewData: [String : [History]]!
    
    @IBOutlet weak var txtMonth: UITextField!
    @IBOutlet weak var CalendarView: JTAppleCalendarView!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var separatorViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var CalendarTableView: UITableView!
    
    let outsideDayColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    let insideDayColor = UIColor.black
    let selectedDayColor = UIColor.white
    let todayColor = UIColor.blue
    let currentSelectedBackgroundColor = #colorLiteral(red: 0.3058823529, green: 0.7490196078, blue: 0.3647058824, alpha: 1)
    let outSideBackgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.6712596318)
    let inSideBackgroundColor = UIColor.white
    let todayBackgroundColor = #colorLiteral(red: 0.5592694578, green: 0.9343472398, blue: 0.885780263, alpha: 0.3976883562)
    let numOfRowsInCalendar = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarView()
        setTxtDay_viewDidLoad()
        setDatePicker_viewDidLoad()
        
        CalendarTableView.dataSource = self
        CalendarTableView.delegate = self
        let temp = HistoryEntity.shared.getHistory(.income)
        let temp1 = HistoryEntity.shared.getHistory(.expense)
        print(temp)
        print(temp1.count)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        CalendarView.reloadData()
        tableViewData = LoadTableViewData(date: datePicker.date)

    }
    
    private func _monthCompare(_ d1: Date, _ d2: Date) -> Bool{
        let calendar = Calendar.current
        return calendar.component(.year, from: d1) == calendar.component(.year, from: d2) && calendar.component(.month, from: d1) == calendar.component(.month, from: d2)
    }
    
    private func LoadTableViewData(date: Date) -> [String : [History]]{
        let temp = HistoryEntity.shared.getHistory()
        var result = [String : [History]]()
        
        let incomeMoney = HistoryEntity.shared.getMoneyOfDate(kind: .income, Time: date, _monthCompare(_:_:))
        dateFormat.dateFormat = "dd MM yyyy"
        
        let calendar = Calendar.current
        
        for object in temp{
            let objectDate = dateFormat.date(from: object.time)!
            
            if calendar.component(.year, from: objectDate) == calendar.component(.year, from: date) && calendar.component(.month, from: objectDate) == calendar.component(.month, from: date) {
                if let _ = result[object.time] {
                    result[object.time]!.append(object)
                }else{
                    var newHistories = [History]()
                    newHistories.append(object)
                    result[object.time] = newHistories
                }
            }
        }
        
        return result
    }
    
    var numOfRowIsSix: Bool {
        get {
            return CalendarView.visibleDates().outdates.count < 7
        }
    }
    
    //MASK: todo
    @objc func dateChanged(DatePicker: UIDatePicker){
        dateFormat.dateFormat = "MMMM"
        txtMonth.text = dateFormat.string(from: DatePicker.date)
        
        dateFormat.dateFormat = "yyyy"
        lblYear.text = dateFormat.string(from: DatePicker.date)
    }
    
    func setupCalendarView(){
        //setup calendar spacing
        CalendarView.minimumInteritemSpacing = 0
        CalendarView.minimumLineSpacing = 0
        
        //today
        let today = Date(timeIntervalSinceNow: 0)
        CalendarView.scrollToDate(today)
        CalendarView.selectDates([today])
        
        //setup labels and text
        CalendarView.visibleDates { (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState){
        guard let validCell = view as? CalendarCell else {return}
        if cellState.isSelected == true{
            validCell.backgroundColor = self.currentSelectedBackgroundColor
            validCell.lblDay.textColor = self.selectedDayColor
        }else{
            if cellState.dateBelongsTo == .thisMonth{
                validCell.backgroundColor = self.inSideBackgroundColor
                
                //day color
                dateFormat.dateFormat = "yyyy MM dd"
                let today = dateFormat.string(from: Date(timeIntervalSinceNow: 0))
                let cellDay = dateFormat.string(from: cellState.date)
                validCell.lblDay.textColor = cellDay == today ?self.todayColor : self.insideDayColor
                validCell.backgroundColor = cellDay == today ?self.todayBackgroundColor : self.inSideBackgroundColor
            }else{
                validCell.backgroundColor = self.outSideBackgroundColor
                validCell.lblDay.textColor = self.outsideDayColor
            }
        }
    }
    
    @objc func viewTapped(){
        view.endEditing(true)
    }
    
    func setDatePicker_viewDidLoad(){
        datePicker.addTarget(self, action: #selector(InputViewController.dateChanged(DatePicker:)), for: .valueChanged)
        datePicker.datePickerMode = .date
    }
    
    func setTxtDay_viewDidLoad(){
        txtMonth.textAlignment = .center
        txtMonth.inputView = datePicker
        txtMonth.delegate = self
        txtMonth.resignFirstResponder()
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo){
        let date = visibleDates.monthDates.first!.date
        dateFormat.dateFormat = "MMMM"
        txtMonth.text = dateFormat.string(from: date)
        
        dateFormat.dateFormat = "yyyy"
        lblYear.text = dateFormat.string(from: date)
    }
}

extension CalendarViewController: JTAppleCalendarViewDataSource{
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        dateFormat.dateFormat = "dd MM yyyy"
        dateFormat.timeZone = Calendar.current.timeZone
        dateFormat.locale = Calendar.current.locale
        let startDate = dateFormat.date(from: "01 01 1970")!
        let endDate = dateFormat.date(from: "31 12 2999")!
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate, numberOfRows: 6,
                                                 calendar: .current,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfGrid,
                                                 firstDayOfWeek: .monday,
                                                 hasStrictBoundaries: true)
        
        return parameters
    }
    
}

extension CalendarViewController: JTAppleCalendarViewDelegate{
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        //todo
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        
        handleCellSelected(view: cell, cellState: cellState)
       
        let cellHidden = cellState.dateBelongsTo != .thisMonth
       
        if !cellHidden{
            cell.isHidden = false
            cell.lblDay.text = cellState.text
            
            let Income = HistoryEntity.shared.getMoneyOfDate(kind: .income, Time: date)
            
            let Expense = HistoryEntity.shared.getMoneyOfDate(kind: .expense, Time: date)
            
            cell.lblIncome.text = String(Income)
            cell.lblExpense.text = String(Expense)
            cell.lblIncome.isHidden = Income > 0 ? false : true
            cell.lblExpense.isHidden = Expense > 0 ? false : true
        }else{
            cell.isHidden = true
        }
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        
        
        setupViewsOfCalendar(from: visibleDates)
        view.layoutIfNeeded()
        
        adjustCalendarViewHeight()
        
        UIView.animate(withDuration: 0.5) { [unowned self] in
            self.view.layoutIfNeeded()
        }
    }
}

//helper
extension CalendarViewController{
    func adjustCalendarViewHeight() {
        adjustCalendarViewHeight(higher: self.numOfRowIsSix)
    }
    
    func adjustCalendarViewHeight(higher: Bool) {
        separatorViewTopConstraint.constant = higher ? 0 : -CalendarView.frame.height / CGFloat(numOfRowsInCalendar)
    }
    
    func select(onVisibleDates visibleDates: DateSegmentInfo) {
        guard let firstDateInMonth = visibleDates.monthDates.first?.date else
        { return }
        
        if firstDateInMonth.isThisMonth() {
            CalendarView.selectDates([Date()])
        } else {
            CalendarView.selectDates([firstDateInMonth])
        }
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Array(tableViewData.values)[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarTableViewCell", for: indexPath) as! CalendarTableViewCell
        
        let history = Array(tableViewData.values)[indexPath.section][indexPath.row]
        
        cell.lblCategory.text = CategoryEntity.shared.getName(ID: history.idCategory)
        cell.lblMoney.text = String(Int(history.money))
        cell.lblMoney.textColor = CategoryEntity.shared.getIntPropertybyID(ID: history.idCategory, property: .kind) == Kind.income.rawValue ? UIColor.income() : UIColor.expense()
        
        let idIcon = CategoryEntity.shared.getIntPropertybyID(ID: history.idCategory, property: .IDIcon)!
        let nameIcon = IconEntity.shared.getName(ID: idIcon)!
        
        cell.imgCategory.image = UIImage(named: nameIcon)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = #colorLiteral(red: 0.3703894019, green: 0.6184459925, blue: 0.08507943898, alpha: 1)
        
        let label = UILabel(frame: CGRect(x: tableView.frame.width/2 - 45, y: 0, width: tableView.frame.width/2, height: 30))
        label.textColor = UIColor.white
        label.text = Array(tableViewData.keys)[section]
        
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
}

extension Date {
    func isThisMonth() -> Bool {
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "yyyy MM"
        
        let dateString = monthFormatter.string(from: self)
        let currentDateString = monthFormatter.string(from: Date())
        return dateString == currentDateString
    }
}

extension UIColor{
    static func expense()->UIColor{
        let color = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        return color
    }
    
    static func income()->UIColor{
        let color = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        return color
    }
}
