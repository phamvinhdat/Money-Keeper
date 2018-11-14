//
//  EditCategoryInputViewController.swift
//  Money Keeper
//
//  Created by pham vinh dat on 11/14/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

import UIKit

class EditCategoryInputViewController: UIViewController {
    
    @IBOutlet weak var categoryTable: UITableView!
    private var segment:UISegmentedControl = UISegmentedControl()
    var root:InputViewController!
    var isExpense:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        root = self.navigationController?.viewControllers[0] as? InputViewController
        
        setCellCategory_viewDidLoad()
        setNavigationbar_viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.root.categoryCollectionView.reloadData()
    }

    func setNavigationbar_viewDidLoad(){
        let btLeft = UIBarButtonItem(image: #imageLiteral(resourceName: "ict-left"), style: .plain, target: self, action: #selector(btnBack_tapped))
        self.navigationItem.leftBarButtonItem = btLeft
        let btRight = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(btnEdit_tapped))
        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.2661139554, green: 1, blue: 0.4494246345, alpha: 1)
        self.navigationItem.rightBarButtonItem = btRight
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
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
        let btn = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(btnSave_tapped))
        self.navigationItem.rightBarButtonItem = btn
    }
    
    @objc func btnSave_tapped(){
        self.categoryTable.isEditing = false
        let btRight = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(btnEdit_tapped))
        self.navigationItem.rightBarButtonItem = btRight
        
        
        self.categoryTable.reloadData()
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
        if indexPath.row == 0{
            cell.lblName.text = "Add Category"
            cell.imgLeft.isHidden = true
        }else{
            cell.imgLeft.isHidden = false
            if self.isExpense{
                let img = UIImage(named: IconEntity.shared.getName(ID: self.root.arrayExpense[indexPath.row].idIcon)!)
                cell.lblName.text = self.root.arrayExpense[indexPath.row].name
                cell.imgLeft.image = img
            }else{
                let img = UIImage(named: IconEntity.shared.getName(ID: self.root.arrayIncome[indexPath.row].idIcon)!)
                cell.lblName.text = self.root.arrayIncome[indexPath.row].name
                cell.imgLeft.image = img
            }
        }
        
        return cell
    }
    
    
}
