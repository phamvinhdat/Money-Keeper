//
//  EditCategoryInputViewController.swift
//  Money Keeper
//
//  Created by pham vinh dat on 11/14/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

import UIKit
import Floaty

class EditCategoryInputViewController: UIViewController {
    
    @IBOutlet weak var floaty: Floaty!
    @IBOutlet weak var categoryTable: UITableView!
    private var segment:UISegmentedControl = UISegmentedControl()
    var root:InputViewController!
    var isExpense:Bool!
    var isSave:Bool!
    var idCategoryDeleted = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFloaty_viewDidLoad()
        root = self.navigationController?.viewControllers[0] as? InputViewController
        isSave = true
        
        setCellCategory_viewDidLoad()
        setNavigationbar_viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.root.categoryCollectionView.reloadData()
    }
    
    func setFloaty_viewDidLoad(){
        self.floaty.addItem("Edit", icon: #imageLiteral(resourceName: "icons8-edit_file")) { (_) in
            self.btnEdit_tapped()
        }
        self.floaty.addItem("Save", icon: #imageLiteral(resourceName: "icons8-save")) { (_) in
            self.btnSave_tapped()
        }
        
        self.view.addSubview(floaty)
    }
    
    func setNavigationbar_viewDidLoad(){
        let btLeft = UIBarButtonItem(image: #imageLiteral(resourceName: "ict-left"), style: .plain, target: self, action: #selector(btnBack_tapped))
        self.navigationItem.leftBarButtonItem = btLeft
        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.2661139554, green: 1, blue: 0.4494246345, alpha: 1)
        segment.insertSegment(withTitle: "Expense", at: 0, animated: true)
        segment.insertSegment(withTitle: "Income", at: 1, animated: true)
        segment.tintColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        segment.selectedSegmentIndex = self.isExpense ? 0 : 1
        segment.addTarget(self, action: #selector(segment_ValueChanged), for: .valueChanged)
        self.navigationItem.titleView = segment
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func btnBack_tapped(){
        self.navigationController?.popViewController(animated: true)
        root.tabBarController?.tabBar.isHidden = false
    }
    
    @objc func btnEdit_tapped(){
        self.categoryTable.isEditing = true
    }
    
    @objc func btnSave_tapped(){
        if !self.isSave{
            self.isSave = !self.isSave
            self.categoryTable.isEditing = false
            let alert = UIAlertController(title: "", message: "Your changes have been saved", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            // change to desired number of seconds (in this case 5 seconds)
            let when = DispatchTime.now() + 3
            DispatchQueue.main.asyncAfter(deadline: when){
                alert.dismiss(animated: true, completion: nil)
            }
            
        }
    }
        
    @objc func segment_ValueChanged(){
        self.isExpense = !self.isExpense
        self.categoryTable.reloadData()
    }
}

extension EditCategoryInputViewController: UITableViewDataSource, UITableViewDelegate{
    
    func setCellCategory_viewDidLoad(){
        self.categoryTable.dataSource = self
        self.categoryTable.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isExpense ? self.root.arrayExpense.count : self.root.arrayIncome.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.categoryTable.dequeueReusableCell(withIdentifier: "TableCell") as! EditCategoryInputTableViewCell
        cell.imgRight.image = #imageLiteral(resourceName: "ict-right")
        if self.isExpense{
            let img = UIImage(named: IconEntity.shared.getName(ID: self.root.arrayExpense[indexPath.row].idIcon)!)
            cell.lblName.text = self.root.arrayExpense[indexPath.row].name
            cell.imgLeft.image = img
        }else{
            let img = UIImage(named: IconEntity.shared.getName(ID: self.root.arrayIncome[indexPath.row].idIcon)!)
            cell.lblName.text = self.root.arrayIncome[indexPath.row].name
            cell.imgLeft.image = img
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            self.isSave = !self.isSave
            var id:Int!
            if self.isExpense{
                id = self.root.arrayExpense[indexPath.row].id
                self.root.arrayExpense.remove(at: indexPath.row)
            }else{
                id = self.root.arrayIncome[indexPath.row].id
                self.root.arrayIncome.remove(at: indexPath.row)
            }
            self.idCategoryDeleted.append(id)
        }
        self.categoryTable.reloadData()
    }
}
