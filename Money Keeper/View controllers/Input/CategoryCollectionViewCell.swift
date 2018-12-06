//
//  CategoryCollectionViewCell.swift
//  Money Keeper
//
//  Created by pham vinh dat on 11/11/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblEdit: UILabel!
    @IBOutlet weak var imgCategory: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override var isSelected: Bool{
        didSet{
            if isSelected{
                self.layer.borderWidth = 2
                self.layer.borderColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
            }
            else{
                self.layer.borderWidth = 1
                self.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            }
        }
    }
}
