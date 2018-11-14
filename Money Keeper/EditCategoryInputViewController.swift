//
//  EditCategoryInputViewController.swift
//  Money Keeper
//
//  Created by pham vinh dat on 11/14/18.
//  Copyright © 2018 pham vinh dat. All rights reserved.
//

import UIKit

class EditCategoryInputViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let root = self.navigationController?.viewControllers[0]
        self.navigationItem.titleView = root!.navigationItem.titleView
       
    }

}
