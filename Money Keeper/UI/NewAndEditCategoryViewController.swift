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
    
    //var
    var strTitle:String!
    
    //MASK: Load
    override func viewDidLoad() {
        super.viewDidLoad()
        setCellIcon_viewDidLoad()
        setNavigationbar_viewDidLoad()
    }
    
    func setNavigationbar_viewDidLoad(){
        let btLeft = UIBarButtonItem(image: #imageLiteral(resourceName: "ict-left"), style: .plain, target: self, action: #selector(btnBack_tapped))
        self.navigationItem.title = self.strTitle
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.2669004202, green: 0.9800816178, blue: 0.4496235847, alpha: 1)]
        self.navigationItem.leftBarButtonItem = btLeft
        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.2661139554, green: 1, blue: 0.4494246345, alpha: 1)
    }
    
    @objc func btnBack_tapped(){
        
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
