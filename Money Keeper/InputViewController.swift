//
//  ViewController.swift
//  Money Keeper
//
//  Created by pham vinh dat on 11/11/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

import UIKit

class InputViewController: UIViewController {
    
    private var datePicker: UIDatePicker?
    var arrayExpense = [Category]()
    var arrayIncome = [Category]()
    var isExpense:Bool = true
    @IBOutlet weak var lblExpense: UILabel!
    @IBOutlet weak var txtNote: UITextField!
    @IBOutlet weak var txtExpenseIncome: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCellCategory_viewDidLoad()
        arrayExpense = CategoryEntity.shared.getTblCategory(KIND: .expense)
        arrayIncome = CategoryEntity.shared.getTblCategory(KIND: .income)
        setDatePicker_viewDidLoad()
        setTxtDay_viewDidLoad()
    }

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
    
    @objc func dateChanged(DatePicker: UIDatePicker){
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "EEEE, yyyy/MM/dd"
        txtDate.text = dateFormat.string(from: DatePicker.date)
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(InputViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        txtDate.inputView = datePicker
    }
}

extension InputViewController:UICollectionViewDataSource, UICollectionViewDelegate{
    
    func setCellCategory_viewDidLoad(){
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        let width = (self.view.frame.size.width - 36)/3
        let height = width*2/3
        let layout = categoryCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isExpense{
            return CategoryEntity.shared.count(KIND: .expense)
        }
        else{
            return CategoryEntity.shared.count(KIND: .income)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as! CategoryCollectionViewCell
        cell.lblName.text = "Row: \(indexPath.row + 1)"
        cell.layer.borderWidth = 1
        cell.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        cell.imgCategory.contentMode = .scaleAspectFit
        if isExpense{
            cell.lblName.text = arrayExpense[indexPath.row].name
            cell.imgCategory.image = UIImage(named: IconEntity.shared.getName(ID: arrayExpense[indexPath.row].idIcon)!)
        }else{
            cell.lblName.text = arrayIncome[indexPath.row].name
            cell.imgCategory.image = UIImage(named: IconEntity.shared.getName(ID: arrayIncome[indexPath.row].idIcon)!)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 2
        cell?.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 1
        cell?.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }
}
