//
//  BKBooksResponse.swift
//  BookStore_RicardoCorreia
//
//  Created by Ric on 27/01/2023.
//

import Foundation

struct BKBooksResponse: Decodable {
    let items: [BKBookResponse]
    let totalItems: Int
}

struct BKBookResponse: Decodable {
    
    let identifier: String
    let title: String?
    let authors: [String]?
    let description: String?
    let buyLink: String?
    let thumbnailLink: String?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case volumeInfo
        case saleInfo
        
        enum VolumeInfoKeys: String, CodingKey {
            case title
            case authors
            case description
            case imageLinks
            
            enum ImageLinkKeys: String, CodingKey {
                case thumbnailLink = "thumbnail"
            }
        }
        
        enum SaleInfoKeys: String, CodingKey {
            case buyLink
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(String.self, forKey: .identifier)
        
        let volumeInfoContainer = try container.nestedContainer(keyedBy: CodingKeys.VolumeInfoKeys.self, forKey: .volumeInfo)
        title = try volumeInfoContainer.decodeIfPresent(String.self, forKey: .title)
        authors = try volumeInfoContainer.decodeIfPresent(Array<String>.self, forKey: .authors)
        description = try volumeInfoContainer.decodeIfPresent(String.self, forKey: .description)
        
        let imageLinksContainer = try volumeInfoContainer.nestedContainer(keyedBy: CodingKeys.VolumeInfoKeys.ImageLinkKeys.self, forKey: .imageLinks)
        thumbnailLink = try imageLinksContainer.decodeIfPresent(String.self, forKey: .thumbnailLink)
        
        let saleInfoContainer = try container.nestedContainer(keyedBy: CodingKeys.SaleInfoKeys.self, forKey: .saleInfo)
        buyLink = try saleInfoContainer.decodeIfPresent(String.self, forKey: .buyLink)
    }
    
    init(identifier: String, title: String?, authors: [String]?, description: String?, buyLink: String?, thumbnailLink: String?)
    {
        self.identifier = identifier
        self.title = title
        self.authors = authors
        self.description = description
        self.buyLink = buyLink
        self.thumbnailLink = thumbnailLink
    }
    
}
