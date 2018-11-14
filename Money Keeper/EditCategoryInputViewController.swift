//
//  EditCategoryInputViewController.swift
//  Money Keeper
//
//  Created by pham vinh dat on 11/14/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

import UIKit

class EditCategoryInputViewController: UIViewController {
    
    private var segment:UISegmentedControl = UISegmentedControl()
    var root:InputViewController? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationbar_viewDidLoad()
        root = self.navigationController?.viewControllers[0] as? InputViewController
    }

    func setNavigationbar_viewDidLoad(){
        self.navigationItem.backBarButtonItem?.tintColor =  #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        segment.insertSegment(withTitle: "Expense", at: 0, animated: true)
        segment.insertSegment(withTitle: "Income", at: 1, animated: true)
        segment.tintColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        segment.selectedSegmentIndex = root!.isExpense ? 0 : 1
        self.navigationItem.titleView = segment
    }
    
}
