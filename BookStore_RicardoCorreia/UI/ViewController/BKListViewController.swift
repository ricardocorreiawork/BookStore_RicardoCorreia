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
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    // MARK: Coordinator
    
    var coordinator: BKCoordinatorListViewInteraction!
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        // Recalculate cell dimensions when the iPad changes orientation.
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: View Setup
    
    private func setupNavigationBar() {
        title = "Book Store"
        
        let favoritesButton = UIButton.favoriteButton(target: self, action: #selector(self.handleTapOnFavoritesButton(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoritesButton)
    }
    
    private func setupView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = .zero
        collectionView.collectionViewLayout = flowLayout
        
        let thumbnailCellNib = UINib(nibName: String(describing: BKThumbnailCell.self), bundle: .main)
        collectionView.register(thumbnailCellNib, forCellWithReuseIdentifier: BKListViewController.thumbnailCellReuseId)
    }
    
    func updateUI() {
        collectionView.reloadData()
    }
    
    // MARK: Actions
    
    @objc private func handleTapOnFavoritesButton(_ button: UIButton) {
        button.isSelected = !button.isSelected
        
        coordinator.didTapFavorites()
    }
    
}

// MARK: - Collection View Data Source

extension BKListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coordinator.numberOfBooks
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let thumbnailCell = collectionView.dequeueReusableCell(withReuseIdentifier: BKListViewController.thumbnailCellReuseId, for: indexPath) as! BKThumbnailCell
        
        let book = coordinator.getBook(at: indexPath.item)
        thumbnailCell.bookId = book.identifier
        
        coordinator.getThumbnailForBook(at: indexPath.item) { [weak thumbnailCell] bookId, image in
            
            // We need to make sure that the image is for this cell,
            // because that by the time the closure is called, the cell might have been reused.
            
            if let cell = thumbnailCell, let thumbnail = image, cell.bookId == bookId {
                cell.populate(with: thumbnail)
            }
        }
        
        return thumbnailCell
    }
    
}

// MARK: - Collection View Delegate

extension BKListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator.didSelectBook(at: indexPath.item)
    }
    
}

// MARK: - Flow Layout Delegate

extension BKListViewController: UICollectionViewDelegateFlowLayout {
    
    private static var sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    private static var interitemSpacing = CGFloat(10)
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return BKListViewController.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = (collectionView.bounds.inset(by: BKListViewController.sectionInsets).width - BKListViewController.interitemSpacing) / 2
        return CGSize(width: width, height: width * 1.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return BKListViewController.interitemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}

// MARK: - Scroll View Delegate

extension BKListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.bounds.height > scrollView.contentSize.height - 100 {
            coordinator.didReachEndOfList()
        }
    }
    
}
