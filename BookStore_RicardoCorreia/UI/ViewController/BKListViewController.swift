//
//  BKListViewController.swift
//  BookStore_RicardoCorreia
//
//  Created by Ric on 26/01/2023.
//

import UIKit

class BKListViewController: UIViewController {
    
    // MARK: Identifiers
    
    private static let thumbnailCellReuseId = "thumbnail"
    
    private static let detailViewControllerId = "detail"
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: Data
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupView()
    }
    
    // MARK: View Setup
    
    private func setupNavigationBar()
    {
        title = "Book Store"
        
        let favoritesButton = UIButton.favoriteButton(target: self, action: #selector(self.handleTapOnFavoritesButton(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoritesButton)
    }
    
    private func setupView()
    {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = .zero
        collectionView.collectionViewLayout = flowLayout
        
        let thumbnailCellNib = UINib(nibName: String(describing: BKThumbnailCell.self), bundle: .main)
        collectionView.register(thumbnailCellNib, forCellWithReuseIdentifier: BKListViewController.thumbnailCellReuseId)
    }
    
    // MARK: Actions
    
    @objc private func handleTapOnFavoritesButton(_ button: UIButton)
    {
        button.isSelected = !button.isSelected
    }
    
}

// MARK: - Collection View Data Source

extension BKListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let thumbnailCell = collectionView.dequeueReusableCell(withReuseIdentifier: BKListViewController.thumbnailCellReuseId, for: indexPath) as! BKThumbnailCell
        return thumbnailCell
    }
    
}

// MARK: - Collection View Delegate

extension BKListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        guard let storyboard = self.storyboard, let navController = self.navigationController else { return }
        
        let detailVC = storyboard.instantiateViewController(withIdentifier: BKListViewController.detailViewControllerId)
        
        navController.pushViewController(detailVC, animated: true)
    }
    
}

// MARK: - Flow Layout Delegate

extension BKListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: collectionView.bounds.width / 2, height: 60)
    }
    
}
