//
//  ViewController.swift
//  Money Keeper
//
//  Created by pham vinh dat on 11/11/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

import UIKit

class InputViewController: UIViewController {

    var isExpense:Bool = true
    @IBOutlet weak var lblExpense: UILabel!
    @IBOutlet weak var txtNote: UITextField!
    @IBOutlet weak var txtExpenseIncome: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCellCategory_viewDidLoad()
    }

    @IBAction func expense_selectorChange(_ sender: Any) {
        //flip the boolean
        self.isExpense = !self.isExpense
        
        //check the bool and set label and collection view
        if(isExpense){
            self.lblExpense.text = "Expense"
            
        }
        else{
            self.lblExpense.text = "Income"
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //dismiss the keyboard when the view tapped on
        self.txtDate.resignFirstResponder()
        self.txtExpenseIncome.resignFirstResponder()
        self.txtNote.resignFirstResponder()
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
        return IconEntity.shared.count()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as! CategoryCollectionViewCell
        cell.imgCategory.backgroundColor = #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1)
        cell.lblName.text = "Row: \(indexPath.row + 1)"
        cell.layer.borderWidth = 1
        cell.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        cell.imgCategory.contentMode = .scaleAspectFit
        cell.imgCategory.image = UIImage(named: IconEntity.shared.getName(ID: indexPath.row + 1)!)
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
