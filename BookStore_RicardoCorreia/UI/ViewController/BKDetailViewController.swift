//
//  BKDetailViewController.swift
//  BookStore_RicardoCorreia
//
//  Created by Ric on 26/01/2023.
//

import UIKit

class BKDetailViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .preferredFont(forTextStyle: .title2)
            titleLabel.numberOfLines = 2
        }
    }
    
    @IBOutlet private weak var authorLabel: UILabel! {
        didSet {
            authorLabel.font = .preferredFont(forTextStyle: .headline)
            authorLabel.numberOfLines = 2
        }
    }
    
    @IBOutlet private weak var descriptionLabel: UILabel!
    {
       didSet {
           descriptionLabel.font = .preferredFont(forTextStyle: .body)
           descriptionLabel.numberOfLines = 0
       }
   }
    
    @IBOutlet private weak var buyLabel: UILabel!
    {
       didSet {
           buyLabel.font = .preferredFont(forTextStyle: .body)
           buyLabel.numberOfLines = 2
       }
   }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }
    
    // MARK: View Setup
    
    private func setupNavigationBar()
    {        
        let favoritesButton = UIButton.favoriteButton(target: self, action: #selector(self.handleTapOnFavoritesButton(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoritesButton)
    }
    
    // MARK: Actions
    
    @objc private func handleTapOnFavoritesButton(_ button: UIButton)
    {
        button.isSelected = !button.isSelected
    }
    
}
