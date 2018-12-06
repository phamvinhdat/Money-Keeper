//
//  ParentCategoryViewController.swift
//  Money Keeper
//
//  Created by andromeda on 11/27/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

import UIKit

class ParentCategoryViewController: UIViewController {

    //MASK: outlet
    @IBOutlet weak var myParentCategoryTableView: UITableView!
    var arrParentCategory:[Category]!
    
    //MASK: Variable
    var isExpense:Bool = true
    
    //MASK: load
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTableData()
        setNavigationbar_viewDidLoad()
        myParentCategoryTableView.dataSource = self
        myParentCategoryTableView.delegate = self
    }
    
    func setNavigationbar_viewDidLoad(){
        let btLeft = UIBarButtonItem(image: #imageLiteral(resourceName: "ict-left"), style: .plain, target: self, action: #selector(btnBack_tapped))
        self.navigationItem.title = "Parent category"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.3703894019, green: 0.6184459925, blue: 0.08507943898, alpha: 1)]
        self.navigationItem.leftBarButtonItem = btLeft
        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.3703894019, green: 0.6184459925, blue: 0.08507943898, alpha: 1)
    }
    
    @objc func btnBack_tapped(){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func loadTableData(){
        self.arrParentCategory = [Category]()
        var arrTemp = [Category]()
        if isExpense{
            arrTemp = CategoryEntity.shared.getCategories(KIND: .expense)
        }else{
            arrTemp = CategoryEntity.shared.getCategories(KIND: .income)
        }
        
        for item in arrTemp{
            //0 is category parent
            if item.parentCategory == 0{
                arrParentCategory.append(item)
            }
        }
        
    }
    
}

extension ParentCategoryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrParentCategory.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PARENTCATEGORYCELL", for: indexPath) as! ParentCategoryTableViewCell
        
        if indexPath.row == 0{
            cell.imgParent.isHidden = true
            cell.lblParent.text = "(No item selected)"
        }else{
            if cell.imgParent.isHidden == true{
                cell.imgParent.isHidden = false
            }
            //the first row is statement
            let category = arrParentCategory[indexPath.row - 1]
            
            cell.lblParent.text = category.name
            let imgName = IconEntity.shared.getName(ID: category.idIcon)
            let img = UIImage(named: imgName!)
            cell.imgParent.image = img
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let count = self.navigationController?.viewControllers.count
        let sb = self.navigationController?.viewControllers[count! - 2] as! NewAndEditCategoryViewController
        
        if indexPath.row == 0{
            sb.parentCategory = nil
        }else{
            //the first of table is statement
            sb.parentCategory = self.arrParentCategory[indexPath.row - 1]
        }
        
        btnBack_tapped()
    }
}

class ParentCategoryTableViewCell: UITableViewCell{
    @IBOutlet weak var lblParent: UILabel!
    @IBOutlet weak var imgParent: UIImageView!
    
}
