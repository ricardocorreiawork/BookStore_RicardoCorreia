//
//  BKCoordinator.swift
//  BookStore_RicardoCorreia
//
//  Created by Ric on 28/01/2023.
//

import UIKit

class BKCoordinator {
    
    private static let listViewControllerId = "list"
    private static let detailViewControllerId = "detail"
    
    private let domainModel = BKDomainModel()
    
    private let navController: UINavigationController
    private weak var listVC: BKListViewController?
    
    private var books: [BKBook] = []
    private var savedBooks: [BKBook] = []
    
    private var isLoadingBooks = false
    private var isShowingSavedBooks = false
    
    private var indexOfBookOpenInDetailView = 0
    
    init(navigationController: UINavigationController) {
        self.navController = navigationController
    }
    
    func start() {
        updateSavedBooks()
        
        guard let storyboard = navController.storyboard else { return }
        
        let listVC = storyboard.instantiateViewController(withIdentifier: BKCoordinator.listViewControllerId) as! BKListViewController
        listVC.coordinator = self
        
        navController.pushViewController(listVC, animated: true)
        
        self.listVC = listVC
    }
    
    private func loadMoreBooks() {
        guard !isLoadingBooks else { return }
        
        isLoadingBooks = true
        
        domainModel.loadBooks(thatContain: "ios", maxResults: 20, startIndex: books.count) { [weak self] response in
            guard let self = self else { return }
            
            let books = response.items.map({ self.makeViewModel(from: $0) })
            
            self.books.append(contentsOf: books)
            self.isLoadingBooks = false
            
            self.listVC?.updateUI()
        }
    }
    
    private func updateSavedBooks() {
        savedBooks = domainModel.loadSavedBooks() ?? []
        
        if isShowingSavedBooks {
            listVC?.updateUI()
        }
    }
    
    private func makeViewModel(from responseModel: BKBookResponse) -> BKBook {
        let isFavorite = savedBooks.contains(where: { $0.identifier == responseModel.identifier })
        
        return BKBook(identifier: responseModel.identifier,
                      title: responseModel.title,
                      authors: responseModel.authors?.joined(separator: ", "),
                      description: responseModel.description,
                      buyLink: responseModel.buyLink,
                      thumbnailLink: responseModel.thumbnailLink,
                      isFavorite: isFavorite)
    }
    
}

// MARK: - List View Interaction

extension BKCoordinator {
    
    var numberOfBooks: Int {
        isShowingSavedBooks ? savedBooks.count : books.count
    }
    
    func getBook(at index: Int) -> BKBook {
        return isShowingSavedBooks ? savedBooks[index] : books[index]
    }
    
    func getThumbnailForBook(at index: Int, completion: @escaping (String, UIImage?) -> Void) {
        let book = getBook(at: index)
        
        guard let thumbnailLink = book.thumbnailLink else {
            completion(book.identifier, nil)
            return
        }
        
        domainModel.loadThumbnail(from: thumbnailLink) { image in
            completion(book.identifier, image)
        }
    }
    
    func didSelectBook(at index: Int) {
        guard let storyboard = navController.storyboard else { return }
        
        let detailVC = storyboard.instantiateViewController(withIdentifier: BKCoordinator.detailViewControllerId) as! BKDetailViewController
        detailVC.coordinator = self
        detailVC.book = getBook(at: index)
        
        navController.pushViewController(detailVC, animated: true)
        
        indexOfBookOpenInDetailView = index
    }
    
    func didTapFavorites() {
        isShowingSavedBooks = !isShowingSavedBooks
        listVC?.updateUI()
    }
    
    func didReachEndOfList() {
        if !isShowingSavedBooks {
            loadMoreBooks()
        }
    }
    
}

// MARK: - Detail View Interaction

extension BKCoordinator {
    
    func didChangeFavoriteStatus(_ flag: Bool) {
        let book = getBook(at: indexOfBookOpenInDetailView)
        
        if flag {
            domainModel.save(book)
            books[indexOfBookOpenInDetailView].isFavorite = true
        } else {
            domainModel.deleteBook(withId: book.identifier)
        }
        updateSavedBooks()
    }
    
    func didTapBuyLink() {
        let book = getBook(at: indexOfBookOpenInDetailView)
        
        if let link = book.buyLink, let url = URL(string: link) {
            UIApplication.shared.open(url)
        }
    }
    
}
