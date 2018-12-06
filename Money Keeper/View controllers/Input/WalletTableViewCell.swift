//
//  WalletTableViewCell.swift
//  Money Keeper
//
//  Created by andromeda on 12/4/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

import UIKit

class WalletTableViewCell: UITableViewCell {

    @IBOutlet weak var lblWalletName: UILabel!
    @IBOutlet weak var imgWallet: UIImageView!
    @IBOutlet weak var lblWalletBalance: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
