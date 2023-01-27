//
//  BKThumbnailCell.swift
//  BookStore_RicardoCorreia
//
//  Created by Ric on 26/01/2023.
//

import UIKit

class BKThumbnailCell: UICollectionViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var imageView: UIImageView!
    
    // MARK: Data
    
    var bookId: String?
    
    // MARK: View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layoutMargins = .zero
        imageView.contentMode = .scaleAspectFit
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        bookId = nil
    }
    
    // MARK: Populating
    
    func populate(with image: UIImage) {
        imageView.image = image
    }
    
}
