//
//  EditCategoryInputTableViewCell.swift
//  Money Keeper
//
//  Created by pham vinh dat on 11/14/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

import UIKit

class NewAndEditCategoryViewController: UIViewController{
    
    //MASK: outlet
    @IBOutlet weak var myIconColectionView: UICollectionView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var CategoryIconCollection: UICollectionView!
    @IBOutlet weak var lblParentCategory: UILabel!
    @IBOutlet weak var viewParentCategory: UIView!
    
    //var
    var strTitle:String!
    var parentCategory: Category? = nil
    
    //MASK: Load
    override func viewDidLoad() {
        super.viewDidLoad()
        setCellIcon_viewDidLoad()
        setNavigationbar_viewDidLoad()
        
        //add action for Parentcategoryview
        let gesture = UITapGestureRecognizer(target: self, action: #selector(viewParentCategory_tapped(_:)))
        viewParentCategory.addGestureRecognizer(gesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let parent = self.parentCategory{
            self.lblParentCategory.text = parent.name
        }else{
            self.lblParentCategory.text = "No item"
        }
    }
    
    func setNavigationbar_viewDidLoad(){
        let btLeft = UIBarButtonItem(image: #imageLiteral(resourceName: "cancel-music"), style: .plain, target: self, action: #selector(cancel_tapped))
        let btRight = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save_tapped))
        self.navigationItem.title = self.strTitle
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.2669004202, green: 0.9800816178, blue: 0.4496235847, alpha: 1)]
        self.navigationItem.leftBarButtonItem = btLeft
        self.navigationItem.rightBarButtonItem = btRight
        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.2661139554, green: 1, blue: 0.4494246345, alpha: 1)
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.2669004202, green: 0.9800816178, blue: 0.4496235847, alpha: 1)
    }
    
    @objc func viewParentCategory_tapped(_ sender: UITapGestureRecognizer){
        let sb = self.storyboard?.instantiateViewController(withIdentifier: "ParentTableView") as! ParentCategoryViewController
        
        //set isExpense
        let SPACE = " "
        let strKind = self.strTitle.components(separatedBy: SPACE)[1]
        
        if strKind.lowercased() == "expense"{
            sb.isExpense = true
        }else{
            sb.isExpense = false
        }
        self.navigationController?.pushViewController(sb, animated: true)
    }
    
    @objc func save_tapped(){
        
    }
    
    @objc func cancel_tapped(){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension NewAndEditCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func setCellIcon_viewDidLoad(){
        self.myIconColectionView.dataSource = self
        self.myIconColectionView.delegate = self
        let width = (self.view.frame.size.width - 48)/4
        let height = width*2/3
        let layout = myIconColectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return IconEntity.shared.count()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ICONCELL", for: indexPath) as! IconNewAndEditCategoryCollectionViewCell
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        if let imgName = IconEntity.shared.getName(ID: indexPath.row + 1){
            let image = UIImage(named: imgName)
            cell.imgIcon.image = image
        }
        
        return cell
    }
}

class IconNewAndEditCategoryCollectionViewCell:UICollectionViewCell{
    
    @IBOutlet weak var imgIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override var isSelected: Bool{
        didSet{
            if isSelected{
                self.layer.borderWidth = 2
                self.layer.borderColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            }else{
                self.layer.borderWidth = 1
                self.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            }
        }
    }
}
