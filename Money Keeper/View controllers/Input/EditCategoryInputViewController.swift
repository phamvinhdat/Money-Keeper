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
    
    //MASK: outlet
    @IBOutlet weak var floaty: Floaty!
    @IBOutlet weak var categoryTable: UITableView!
    
    //MASK: variable
    private var segment:UISegmentedControl = UISegmentedControl()
    var root:InputViewController!
    var isExpense:Bool!
    var isSave:Bool! = true
    var categoryDeleted = [Int]()
    
    //MASK: load
    override func viewDidLoad() {
        super.viewDidLoad()
        setFloaty_viewDidLoad()
        root = self.navigationController?.viewControllers[0] as? InputViewController
        
        setCellCategory_viewDidLoad()
        setNavigationbar_viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.root.categoryCollectionView.reloadData()
    }
    
    //MASK: action
    
    
    //MASK: todo
    func setFloaty_viewDidLoad(){
        self.floaty.addItem("Edit", icon: #imageLiteral(resourceName: "icons8-edit_file")) { (f) in
            if f.title == "Edit"{
                f.title = "Done"
                f.iconImageView.image = #imageLiteral(resourceName: "icons8-checked_checkbox_filled")
                self.categoryTable.isEditing = true
            }else{
                f.title = "Edit"
                f.iconImageView.image = #imageLiteral(resourceName: "icons8-edit_file")
                self.categoryTable.isEditing = false
            }
        }
        self.floaty.addItem("Save", icon: #imageLiteral(resourceName: "icons8-save")) { (_) in
            self.btnSave_tapped(delay: 3)
        }
        
        //new category
        self.floaty.addItem("New Category", icon: #imageLiteral(resourceName: "icons8-add_file_filled")) { (_) in
            let sb = self.storyboard?.instantiateViewController(withIdentifier: "NewAndEditCategory") as! NewAndEditCategoryViewController
            
            //set title for table category view
            if self.isExpense{
                sb.strTitle = "New Expense"
            }else{
                sb.strTitle = "New Income"
            }
            self.navigationController?.pushViewController(sb, animated: true)
        }
        
        self.view.addSubview(floaty)
    }
    
    func setNavigationbar_viewDidLoad(){
        let btLeft = UIBarButtonItem(image: #imageLiteral(resourceName: "ict-left"), style: .plain, target: self, action: #selector(btnBack_tapped))
        self.navigationItem.leftBarButtonItem = btLeft
        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.3703894019, green: 0.6184459925, blue: 0.08507943898, alpha: 1)
        segment.insertSegment(withTitle: "Expense", at: 0, animated: true)
        segment.insertSegment(withTitle: "Income", at: 1, animated: true)
        segment.tintColor = #colorLiteral(red: 0.3703894019, green: 0.6184459925, blue: 0.08507943898, alpha: 1)
        segment.selectedSegmentIndex = self.isExpense ? 0 : 1
        segment.addTarget(self, action: #selector(segment_ValueChanged), for: .valueChanged)
        self.navigationItem.titleView = segment
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func btnBack_tapped(){
        if !self.isSave{
            let alert = UIAlertController(title: "Your changes have not been saved", message: "Do you want to save the changes?", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Yes", style: .default) { (_) in
                self.btnSave_tapped(delay: 0)
                self.root.loadArrayExpense()
                self.root.loadArrayIncome()
                self.root.categoryCollectionView.reloadData()
            }
            let action2 = UIAlertAction(title: "No", style: .default, handler: nil)
            alert.addAction(action1)
            alert.addAction(action2)
            
            let screen = UIScreen.main
            let screenBounds = screen.bounds
            let alertWindow = UIWindow(frame: screenBounds)
            alertWindow.windowLevel = UIWindow.Level.alert
            
            let vc = UIViewController()
            alertWindow.rootViewController = vc
            alertWindow.screen = screen
            alertWindow.isHidden = false
            vc.present(alert, animated: true)
        }
        //back
        self.root.loadArrayExpense()
        self.root.loadArrayIncome()
        self.root.categoryCollectionView.reloadData()
        self.navigationController?.popViewController(animated: true)
        root.tabBarController?.tabBar.isHidden = false
    }
    
    func btnSave_tapped(delay: Double){
        if !self.isSave{
            self.isSave = !self.isSave
            self.categoryTable.isEditing = false
            let alert = UIAlertController(title: nil, message: "Your changes have been saved", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            //update database
            for i in categoryDeleted{
                CategoryEntity.shared.remove(id: i)
            }
            
            // change to desired number of seconds
            if delay > 0
            {
                let when = DispatchTime.now() + delay
                DispatchQueue.main.asyncAfter(deadline: when){
                    alert.dismiss(animated: true, completion: nil)
                }
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
            self.isSave = false
            var id:Int!
            if self.isExpense{
                id = self.root.arrayExpense[indexPath.row].id
                self.root.arrayExpense.remove(at: indexPath.row)
            }else{
                id = self.root.arrayIncome[indexPath.row].id
                self.root.arrayIncome.remove(at: indexPath.row)
            }
            self.categoryDeleted.append(id)
        }
        self.categoryTable.reloadData()
    }
}

class EditCategoryInputTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgLeft: UIImageView!
    @IBOutlet weak var imgRight: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
