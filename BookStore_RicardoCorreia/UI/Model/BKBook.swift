//
//  BKBook.swift
//  BookStore_RicardoCorreia
//
//  Created by Ric on 28/01/2023.
//

import Foundation

struct BKBook {
    let identifier: String
    let title: String?
    let authors: String?
    let description: String?
    let buyLink: String?
    let thumbnailLink: String?
    var isFavorite: Bool
}
