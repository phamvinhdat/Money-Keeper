//
//  ViewController.swift
//  Money Keeper
//
//  Created by pham vinh dat on 11/11/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

import UIKit

class InputViewController: UIViewController, UITextFieldDelegate{
    
    //MASK: Variable
    private var datePicker: UIDatePicker?
    var arrayExpense = [Category]()
    var arrayIncome = [Category]()
    var isExpense:Bool = true
    var history = History()
    
    //MASK: outlet
    @IBOutlet weak var lblExpense: UILabel!
    @IBOutlet weak var txtNote: UITextField!
    @IBOutlet weak var txtExpenseIncome: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblWallet: UILabel!
    @IBOutlet weak var WalletView: UIView!
    
    //MASK: load
    override func viewDidLoad() {
        super.viewDidLoad()

        loadArrayIncome()
        loadArrayExpense()
        setCellCategory_viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        setDatePicker_viewDidLoad()
        setTxtDay_viewDidLoad()
        setWalletView_viewDidLoad()
        
        //set default history
        history.idWallet = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        txtExpenseIncome.setAsNumericKeyboard(delegate: self)
    }
    
    func loadArrayExpense(){
        arrayExpense = CategoryEntity.shared.getTblCategory(KIND: .expense)
    }
    
    func loadArrayIncome(){
        arrayIncome = CategoryEntity.shared.getTblCategory(KIND: .income)
    }
    
    //MASK: Action
    @IBAction func expense_selectorChange(_ sender: Any) {
        //flip the boolean
        self.isExpense = !self.isExpense
        categoryCollectionView.reloadData()
        
        //check the bool and set label and collection view
        if isExpense{
            self.lblExpense.text = "Expense"
        }
        else{
            self.lblExpense.text = "Income"
        }
    }
    
    @IBAction func btnDay_touchUpInside(_ sender: UIButton) {
        var isNextDay = true
        if sender.tag == 1{
            isNextDay = false
        }
        datePicker!.date = NSDate(timeInterval: TimeInterval(60 * 60 * (isNextDay == true ? 24 : -24)), since: datePicker!.date) as Date
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "EEEE, yyyy/MM/dd"
        txtDate.text = dateFormat.string(from: datePicker!.date)
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        if canSubmit(){
            
        }
    }
    
    @IBAction func txtExpenseIcome_editingEnd(_ sender: Any) {
        if canSubmit(){
            btnSubmit.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        }else{
            btnSubmit.backgroundColor = #colorLiteral(red: 0.5000228286, green: 0.9820134044, blue: 0.496680975, alpha: 1)
        }
    }
    
    //MASK: todo
    @objc func dateChanged(DatePicker: UIDatePicker){
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "EEEE, yyyy/MM/dd"
        txtDate.text = dateFormat.string(from: DatePicker.date)
    }

    @objc func viewTapped(){
        view.endEditing(true)
    }
    
    func setDatePicker_viewDidLoad(){
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(InputViewController.dateChanged(DatePicker:)), for: .valueChanged)
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
    
    func setWalletView_viewDidLoad(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(walletViewTapped))
        self.WalletView.addGestureRecognizer(gesture)
    }
    
    @objc func walletViewTapped(){
        let sb = self.storyboard?.instantiateViewController(withIdentifier: "WalletViewController")
        self.navigationController?.pushViewController(sb!, animated: true)
    }
}

extension InputViewController:UICollectionViewDataSource, UICollectionViewDelegate{
    
    func setCellCategory_viewDidLoad(){
        self.categoryCollectionView.dataSource = self
        self.categoryCollectionView.delegate = self
        let width = (self.view.frame.size.width - 36)/3
        let height = width*2/3
        let layout = categoryCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: height)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isExpense{
            return CategoryEntity.shared.count(KIND: .expense) + 1//cell edit in the last
        }
        else{
            return CategoryEntity.shared.count(KIND: .income) + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as! CategoryCollectionViewCell
        cell.lblName.text = "Row: \(indexPath.row + 1)"
        cell.layer.borderWidth = 1
        cell.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        cell.imgCategory.contentMode = .scaleAspectFit
        let numberofCell = isExpense ? arrayExpense.count : arrayIncome.count
        
        if(indexPath.row == numberofCell){
            cell.lblEdit.isHidden = false
            cell.lblEdit.text = "Edit >"
            cell.lblEdit.contentMode = .center
            cell.imgCategory.isHidden = true
            cell.lblName.isHidden = true
        }
        else{
            cell.lblName.isHidden = false
            cell.imgCategory.isHidden = false
            cell.lblEdit.isHidden = true
            if isExpense{
                cell.lblName.text = arrayExpense[indexPath.row].name
                cell.imgCategory.image = UIImage(named: IconEntity.shared.getName(ID: arrayExpense[indexPath.row].idIcon)!)
            }else{
                cell.lblName.text = arrayIncome[indexPath.row].name
                cell.imgCategory.image = UIImage(named: IconEntity.shared.getName(ID: arrayIncome[indexPath.row].idIcon)!)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let numberofCell = isExpense ? arrayExpense.count : arrayIncome.count
        if indexPath.row == numberofCell{
            let sb = storyboard?.instantiateViewController(withIdentifier: "EditCategoryView") as! EditCategoryInputViewController
            sb.isExpense = self.isExpense
            self.navigationController?.pushViewController(sb, animated: true)
        }
        else{
            lblCategory.text = isExpense ? arrayExpense[indexPath.row].name : arrayIncome[indexPath.row].name
            if canSubmit(){
                btnSubmit.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            }
        }
    }
    
    private func canSubmit()->Bool{
        if let txt =  self.txtExpenseIncome.text, txt.count > 0{//check money
            if let double = Double(txt), double > 0{
                if lblCategory.text?.lowercased() != "no selected"{
                    return true
                }
            }
        }
        return false
    }
}

extension InputViewController: NumericKeyboardDelegate{
    func numericKeyPressed(key: Int) {
        //todo
    }
    
    func numericHandlePressed(symbol: String) {
        //todo
    }
    
    func numericSymbolPressed(symbol: String) {
        //todo
    }

}
