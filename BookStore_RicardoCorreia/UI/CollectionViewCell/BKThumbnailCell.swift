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
    
    // MARK: View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layoutMargins = .zero
        backgroundColor = .blue
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }
    
    // MARK: Populating
    
    func populate(with image: UIImage) {
        imageView.image = image
    }
    
}
