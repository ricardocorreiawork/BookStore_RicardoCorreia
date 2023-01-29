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
            titleLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet private weak var authorLabel: UILabel! {
        didSet {
            authorLabel.font = .preferredFont(forTextStyle: .headline)
            authorLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet private weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = .preferredFont(forTextStyle: .body)
            descriptionLabel.numberOfLines = 0
        }
    }
    
    @IBOutlet private weak var buyLabel: UILabel! {
        didSet {
            buyLabel.font = .preferredFont(forTextStyle: .body)
            buyLabel.numberOfLines = 3
        }
    }
    
    private weak var favoriteButton: UIButton?
    
    // MARK: Coordinator
    
    var coordinator: BKCoordinatorDetailViewInteraction!
    
    // MARK: Data
    
    var book: BKBook?
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        // Populate view
        if let book = self.book {
            favoriteButton?.isSelected = book.isFavorite
            titleLabel.text = book.title
            authorLabel.text = book.authors
            descriptionLabel.text = book.description
            
            if let buyLink = book.buyLink {
                buyLabel.attributedText = NSAttributedString(string: buyLink, attributes: [.link: buyLink])
                
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnBuyLink))
                buyLabel.addGestureRecognizer(tapRecognizer)
                buyLabel.isUserInteractionEnabled = true
            }
        }
    }
    
    // MARK: View Setup
    
    private func setupNavigationBar() {
        let favoriteButton = UIButton.favoriteButton(target: self, action: #selector(self.handleTapOnFavoritesButton(_:)))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
        
        self.favoriteButton = favoriteButton
    }
    
    // MARK: Actions
    
    @objc private func handleTapOnFavoritesButton(_ button: UIButton) {
        button.isSelected = !button.isSelected
        
        coordinator.didChangeFavoriteStatus(button.isSelected)
    }
    
    @objc private func handleTapOnBuyLink() {
        coordinator.didTapBuyLink()
    }
    
}
