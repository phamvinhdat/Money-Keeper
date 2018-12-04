//
//  WalletViewController.swift
//  Money Keeper
//
//  Created by andromeda on 12/2/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController {
    
    //MASK: -outlet
    @IBOutlet weak var walletTable: UITableView!
    
    let wallets = WalletEntity.shared.getWallets()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        walletTable.dataSource = self
        walletTable.delegate = self
        setNavigationbar_viewDidLoad()
    }
    
    func setNavigationbar_viewDidLoad(){
        let btLeft = UIBarButtonItem(image: #imageLiteral(resourceName: "ict-left"), style: .plain, target: self, action: #selector(btnBack_tapped))
        let btRight = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(btnAdd_tapped))
        self.navigationItem.leftBarButtonItem = btLeft
        self.navigationItem.rightBarButtonItem = btRight
        self.navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.3703894019, green: 0.6184459925, blue: 0.08507943898, alpha: 1)
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.3703894019, green: 0.6184459925, blue: 0.08507943898, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.3703894019, green: 0.6184459925, blue: 0.08507943898, alpha: 1)]
        self.navigationItem.title = "Wallet"
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func btnBack_tapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnAdd_tapped(){
        
    }
}

extension WalletViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wallets.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletTableViewCell", for: indexPath) as! WalletTableViewCell
        if indexPath.row == 0 {
            cell.lblWallet.text = "New Wallet"
        }else{
            if let imgName = IconEntity.shared.getName(ID: wallets[indexPath.row - 1].idIcon){
                cell.imgWallet.image = UIImage(named: imgName)
            }
            cell.lblWallet.text = wallets[indexPath.row - 1].name
        }
        return cell
    }
}
