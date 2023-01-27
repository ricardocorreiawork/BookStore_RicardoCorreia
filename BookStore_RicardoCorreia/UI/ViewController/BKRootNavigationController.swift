//
//  BKRootNavigationController.swift
//  BookStore_RicardoCorreia
//
//  Created by Ric on 28/01/2023.
//

import UIKit

class BKRootNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coordinator = BKCoordinator(navigationController: self)
        coordinator.start()
    }
    
}
