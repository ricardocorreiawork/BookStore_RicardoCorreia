//
//  BKDomainModel.swift
//  BookStore_RicardoCorreia
//
//  Created by Ric on 28/01/2023.
//

import UIKit
import CoreData

class BKDomainModel {
    
    private let service = BKBooksService()
    
    // MARK: Loading Books
    
    func loadBooks(thatContain searchQuery: String, maxResults: Int, startIndex: Int, completion: @escaping (BKBooksResponse) -> Void)
    {
        service.requestBooks(thatContain: searchQuery, maxResults: maxResults, startIndex: startIndex, completion: completion)
    }
    
    // MARK: Loading Thumbnails
    
    private var thumbnailCache: [String: UIImage] = [:]
    
    func loadThumbnail(from link: String, completion: @escaping (UIImage?) -> Void)
    {
        if let cachedImage = thumbnailCache[link] {
            return completion(cachedImage)
        }
        service.loadImage(from: link) { [weak self] image in
            if let downloadedImage = image {
                self?.thumbnailCache[link] = downloadedImage
            }
            completion(image)
        }
    }
    
    // MARK: Loading Saved Books
    
    private static let bookEntityName = "Book"
    
    private enum BookAttributeName: String {
        case identifier
        case title
        case authors
        case description = "bookDescription"
        case thumbnailLink
        case buyLink
    }
    
    private var managedObjectContext: NSManagedObjectContext? {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            return appDelegate.persistentContainer.viewContext
        }
        return nil
    }
    
    func save(_ book: BKBook)
    {
        guard let managedContext = self.managedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: BKDomainModel.bookEntityName, in: managedContext)
        else { return }
        
        let managedBook = NSManagedObject(entity: entity, insertInto: managedContext)
        managedBook.setValue(book.identifier, forKeyPath: BookAttributeName.identifier.rawValue)
        managedBook.setValue(book.title, forKeyPath: BookAttributeName.title.rawValue)
        managedBook.setValue(book.authors, forKeyPath: BookAttributeName.authors.rawValue)
        managedBook.setValue(book.description, forKeyPath: BookAttributeName.description.rawValue)
        managedBook.setValue(book.thumbnailLink, forKeyPath: BookAttributeName.thumbnailLink.rawValue)
        managedBook.setValue(book.buyLink, forKeyPath: BookAttributeName.buyLink.rawValue)
        
        do {
            try managedContext.save()
        } catch {}
    }
    
    func deleteBook(withId bookId: String)
    {
        guard let managedContext = self.managedObjectContext else { return }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: BKDomainModel.bookEntityName)
        fetchRequest.predicate = NSPredicate(format: "\(BookAttributeName.identifier.rawValue) == %@", bookId)
        fetchRequest.fetchLimit = 1
        
        do {
            if let managedBook = try managedContext.fetch(fetchRequest).first {
                managedContext.delete(managedBook)
                try managedContext.save()
            }
        } catch {}
    }
    
    func loadSavedBooks() -> [BKBook]?
    {
        guard let managedContext = self.managedObjectContext else { return nil }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: BKDomainModel.bookEntityName)
        
        do {
            let managedBooks = try managedContext.fetch(fetchRequest)
            
            return managedBooks.compactMap { managedBook in
                guard let bookId = managedBook.value(forKeyPath: BookAttributeName.identifier.rawValue) as? String else { return nil }
                
                return BKBook(
                    identifier:    bookId,
                    title:         managedBook.value(forKeyPath: BookAttributeName.title.rawValue) as? String,
                    authors:       managedBook.value(forKeyPath: BookAttributeName.authors.rawValue) as? String,
                    description:   managedBook.value(forKeyPath: BookAttributeName.description.rawValue) as? String,
                    buyLink:       managedBook.value(forKeyPath: BookAttributeName.buyLink.rawValue) as? String,
                    thumbnailLink: managedBook.value(forKeyPath: BookAttributeName.thumbnailLink.rawValue) as? String,
                    isFavorite: true)
            }
        } catch {
            return nil
        }
    }
    
}
